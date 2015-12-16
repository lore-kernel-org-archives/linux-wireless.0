Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968AbbLPKOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 05:14:37 -0500
Date: Wed, 16 Dec 2015 13:14:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: akarwar@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: add support for Marvell USB8797 chipset
Message-ID: <20151216101428.GA12056@mwanda> (sfid-20151216_111443_035083_E3EE5E7D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Amitkumar Karwar,

The patch 4daffe354366: "mwifiex: add support for Marvell USB8797
chipset" from Apr 18, 2012, leads to the following static checker
warning:

	drivers/net/wireless/marvell/mwifiex/usb.c:1108 mwifiex_prog_fw_w_helper()
	warn: should this be 'retries == -1'

drivers/net/wireless/marvell/mwifiex/usb.c
   993  static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
   994                                      struct mwifiex_fw_image *fw)
   995  {
   996          int ret = 0;
   997          u8 *firmware = fw->fw_buf, *recv_buff;
   998          u32 retries = USB8XXX_FW_MAX_RETRY, dlen;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
retries starts set to 3.

   999          u32 fw_seqnum = 0, tlen = 0, dnld_cmd = 0;
  1000          struct fw_data *fwdata;
  1001          struct fw_sync_header sync_fw;
  1002          u8 check_winner = 1;
  1003  
  1004          if (!firmware) {
  1005                  mwifiex_dbg(adapter, ERROR,
  1006                              "No firmware image found! Terminating download\n");
  1007                  ret = -1;
  1008                  goto fw_exit;
  1009          }
  1010  
  1011          /* Allocate memory for transmit */
  1012          fwdata = kzalloc(FW_DNLD_TX_BUF_SIZE, GFP_KERNEL);
  1013          if (!fwdata) {
  1014                  ret = -ENOMEM;
  1015                  goto fw_exit;
  1016          }
  1017  
  1018          /* Allocate memory for receive */
  1019          recv_buff = kzalloc(FW_DNLD_RX_BUF_SIZE, GFP_KERNEL);
  1020          if (!recv_buff)
  1021                  goto cleanup;
  1022  
  1023          do {
  1024                  /* Send pseudo data to check winner status first */
  1025                  if (check_winner) {
  1026                          memset(&fwdata->fw_hdr, 0, sizeof(struct fw_header));
  1027                          dlen = 0;
  1028                  } else {
  1029                          /* copy the header of the fw_data to get the length */
  1030                          memcpy(&fwdata->fw_hdr, &firmware[tlen],
  1031                                 sizeof(struct fw_header));
  1032  
  1033                          dlen = le32_to_cpu(fwdata->fw_hdr.data_len);
  1034                          dnld_cmd = le32_to_cpu(fwdata->fw_hdr.dnld_cmd);
  1035                          tlen += sizeof(struct fw_header);
  1036  
  1037                          memcpy(fwdata->data, &firmware[tlen], dlen);
  1038  
  1039                          fwdata->seq_num = cpu_to_le32(fw_seqnum);
  1040                          tlen += dlen;
  1041                  }
  1042  
  1043                  /* If the send/receive fails or CRC occurs then retry */
  1044                  while (retries--) {

Because this is a postop the loop ends when retries is UINT_MAX.

  1045                          u8 *buf = (u8 *)fwdata;
  1046                          u32 len = FW_DATA_XMIT_SIZE;
  1047  
  1048                          /* send the firmware block */
  1049                          ret = mwifiex_write_data_sync(adapter, buf, &len,
  1050                                                  MWIFIEX_USB_EP_CMD_EVENT,
  1051                                                  MWIFIEX_USB_TIMEOUT);
  1052                          if (ret) {
  1053                                  mwifiex_dbg(adapter, ERROR,
  1054                                              "write_data_sync: failed: %d\n",
  1055                                              ret);
  1056                                  continue;

If this fails 3 times for example.

  1057                          }
  1058  
  1059                          buf = recv_buff;
  1060                          len = FW_DNLD_RX_BUF_SIZE;
  1061  
  1062                          /* Receive the firmware block response */
  1063                          ret = mwifiex_read_data_sync(adapter, buf, &len,
  1064                                                  MWIFIEX_USB_EP_CMD_EVENT,
  1065                                                  MWIFIEX_USB_TIMEOUT);
  1066                          if (ret) {
  1067                                  mwifiex_dbg(adapter, ERROR,
  1068                                              "read_data_sync: failed: %d\n",
  1069                                              ret);
  1070                                  continue;

Or this.


  1071                          }
  1072  
  1073                          memcpy(&sync_fw, recv_buff,
  1074                                 sizeof(struct fw_sync_header));
  1075  
  1076                          /* check 1st firmware block resp for highest bit set */
  1077                          if (check_winner) {
  1078                                  if (le32_to_cpu(sync_fw.cmd) & 0x80000000) {
  1079                                          mwifiex_dbg(adapter, WARN,
  1080                                                      "USB is not the winner %#x\n",
  1081                                                      sync_fw.cmd);
  1082  
  1083                                          /* returning success */
  1084                                          ret = 0;
  1085                                          goto cleanup;
  1086                                  }
  1087  
  1088                                  mwifiex_dbg(adapter, MSG,
  1089                                              "start to download FW...\n");
  1090  
  1091                                  check_winner = 0;
  1092                                  break;

If we break here then it's possible for retries to be zero.

  1093                          }
  1094  
  1095                          /* check the firmware block response for CRC errors */
  1096                          if (sync_fw.cmd) {
  1097                                  mwifiex_dbg(adapter, ERROR,
  1098                                              "FW received block with CRC %#x\n",
  1099                                              sync_fw.cmd);
  1100                                  ret = -1;
  1101                                  continue;
  1102                          }
  1103  
  1104                          retries = USB8XXX_FW_MAX_RETRY;
  1105                          break;
  1106                  }
  1107                  fw_seqnum++;
  1108          } while ((dnld_cmd != FW_HAS_LAST_BLOCK) && retries);
                                                            ^^^^^^^
This test is wrong.  I guess we could change retries to int and change
this test to retries >= 0?  But then in the last iteration through the
big outside loop we wouldn't go into the smaller inside loop.  We would
just update dlen, tlen and fw_seqnum and then exit.

  1109  
  1110  cleanup:
  1111          mwifiex_dbg(adapter, MSG,
  1112                      "info: FW download over, size %d bytes\n", tlen);
  1113  
  1114          kfree(recv_buff);
  1115          kfree(fwdata);
  1116  
  1117          if (retries)
  1118                  ret = 0;

And this as well.

	if (retries >= 0)
		ret = 0;


  1119  fw_exit:
  1120          return ret;
  1121  }

eegards,
dan carpenter
