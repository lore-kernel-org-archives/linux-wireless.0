Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28429 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdIAIaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 04:30:52 -0400
Date: Fri, 1 Sep 2017 11:30:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: shaul.triebitz@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] iwlwifi: mvm: add station before allocating a queue
Message-ID: <20170901083022.t6e2zlrqfyebrf5t@mwanda> (sfid-20170901_103056_863745_078F39B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Shaul Triebitz,

The patch 732d06e9d9cf: "iwlwifi: mvm: add station before allocating
a queue" from Jul 10, 2017, leads to the following static checker
warning:

	drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1312 iwl_mvm_add_int_sta_common()
	error: uninitialized symbol 'status'.

drivers/net/wireless/intel/iwlwifi/mvm/sta.c
  1281  static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
  1282                                        struct iwl_mvm_int_sta *sta,
  1283                                        const u8 *addr,
  1284                                        u16 mac_id, u16 color)
  1285  {
  1286          struct iwl_mvm_add_sta_cmd cmd;
  1287          int ret;
  1288          u32 status;
                ^^^^^^^^^^
  1289  
  1290          lockdep_assert_held(&mvm->mutex);
  1291  
  1292          memset(&cmd, 0, sizeof(cmd));
  1293          cmd.sta_id = sta->sta_id;
  1294          cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
  1295                                                               color));
  1296          if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
  1297                  cmd.station_type = sta->type;
  1298  
  1299          if (!iwl_mvm_has_new_tx_api(mvm))
  1300                  cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
  1301          cmd.tid_disable_tx = cpu_to_le16(0xffff);
  1302  
  1303          if (addr)
  1304                  memcpy(cmd.addr, addr, ETH_ALEN);
  1305  
  1306          ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA,
  1307                                            iwl_mvm_add_sta_cmd_size(mvm),
  1308                                            &cmd, &status);
                                                         ^^^^^^
  1309          if (ret)
  1310                  return ret;
  1311  
  1312          switch (status & IWL_ADD_STA_STATUS_MASK) {
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1313          case ADD_STA_SUCCESS:
  1314                  IWL_DEBUG_INFO(mvm, "Internal station added.\n");
  1315                  return 0;
  1316          default:
  1317                  ret = -EIO;
  1318                  IWL_ERR(mvm, "Add internal station failed, status=0x%x\n",
  1319                          status);
  1320                  break;
  1321          }
  1322          return ret;
  1323  }

The problem here is this code from iwl_mvm_send_cmd_status()

drivers/net/wireless/intel/iwlwifi/mvm/utils.c
   157          cmd->flags |= CMD_WANT_SKB;
   158  
   159          ret = iwl_trans_send_cmd(mvm->trans, cmd);
   160          if (ret == -ERFKILL) {
   161                  /*
   162                   * The command failed because of RFKILL, don't update
   163                   * the status, leave it as success and return 0.
   164                   */
   165                  return 0;

We return zero without setting "status".  Shouldn't we set *status = 0;?

   166          } else if (ret) {
   167                  return ret;
   168          }
   169  
   170          pkt = cmd->resp_pkt;

regards,
dan carpenter
