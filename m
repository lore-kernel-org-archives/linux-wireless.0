Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35800 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbcJKKva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 06:51:30 -0400
Date: Tue, 11 Oct 2016 13:50:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ido@wizery.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] iwlwifi: mvm: Add mem debugfs entry
Message-ID: <20161011105027.GA29933@mwanda> (sfid-20161011_125139_004287_A864D8CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ido Yariv,

The patch 2b55f43f8e47: "iwlwifi: mvm: Add mem debugfs entry" from
Aug 23, 2016, leads to the following static checker warning:

	drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1561 iwl_dbgfs_mem_read()
	warn: unsigned 'len' is never less than zero.

drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
  1521  static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
  1522                                    size_t count, loff_t *ppos)
  1523  {
  1524          struct iwl_mvm *mvm = file->private_data;
  1525          struct iwl_dbg_mem_access_cmd cmd = {};
  1526          struct iwl_dbg_mem_access_rsp *rsp;
  1527          struct iwl_host_cmd hcmd = {
  1528                  .flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
  1529                  .data = { &cmd, },
  1530                  .len = { sizeof(cmd) },
  1531          };
  1532          size_t delta, len;
                              ^^^
Unsigned.

  1533          ssize_t ret;
  1534  
  1535          hcmd.id = iwl_cmd_id(*ppos >> 24 ? UMAC_RD_WR : LMAC_RD_WR,
  1536                               DEBUG_GROUP, 0);
  1537          cmd.op = cpu_to_le32(DEBUG_MEM_OP_READ);
  1538  
  1539          /* Take care of alignment of both the position and the length */
  1540          delta = *ppos & 0x3;
  1541          cmd.addr = cpu_to_le32(*ppos - delta);
  1542          cmd.len = cpu_to_le32(min(ALIGN(count + delta, 4) / 4,
  1543                                    (size_t)DEBUG_MEM_MAX_SIZE_DWORDS));
  1544  
  1545          mutex_lock(&mvm->mutex);
  1546          ret = iwl_mvm_send_cmd(mvm, &hcmd);
  1547          mutex_unlock(&mvm->mutex);
  1548  
  1549          if (ret < 0)
  1550                  return ret;
  1551  
  1552          rsp = (void *)hcmd.resp_pkt->data;
  1553          if (le32_to_cpu(rsp->status) != DEBUG_MEM_STATUS_SUCCESS) {
  1554                  ret = -ENXIO;
  1555                  goto out;
  1556          }
  1557  
  1558          len = min((size_t)le32_to_cpu(rsp->len) << 2,
  1559                    iwl_rx_packet_payload_len(hcmd.resp_pkt) - sizeof(*rsp));
  1560          len = min(len - delta, count);
  1561          if (len < 0) {
                    ^^^^^^^
Unpossible.

  1562                  ret = -EFAULT;
  1563                  goto out;
  1564          }
  1565  
  1566          ret = len - copy_to_user(user_buf, (void *)rsp->data + delta, len);
  1567          *ppos += ret;
  1568  
  1569  out:
  1570          iwl_free_resp(&hcmd);
  1571          return ret;
  1572  }

regards,
dan carpenter
