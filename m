Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50505 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbbFZJad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 05:30:33 -0400
Date: Fri, 26 Jun 2015 12:30:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: netlink: Implement vendor command support
Message-ID: <20150626093018.GA28810@mwanda> (sfid-20150626_113316_694575_0B8DE5F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Samuel Ortiz,

The patch 9e58095f9660: "NFC: netlink: Implement vendor command
support" from Oct 14, 2014, leads to the following static checker
warning:

	net/nfc/netlink.c:1522 nfc_genl_vendor_cmd()
	warn: can 'data' even be NULL?

net/nfc/netlink.c
  1498  static int nfc_genl_vendor_cmd(struct sk_buff *skb,
  1499                                 struct genl_info *info)
  1500  {
  1501          struct nfc_dev *dev;
  1502          struct nfc_vendor_cmd *cmd;
  1503          u32 dev_idx, vid, subcmd;
  1504          u8 *data;
  1505          size_t data_len;
  1506          int i;
  1507  
  1508          if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
  1509              !info->attrs[NFC_ATTR_VENDOR_ID] ||
  1510              !info->attrs[NFC_ATTR_VENDOR_SUBCMD])
  1511                  return -EINVAL;
  1512  
  1513          dev_idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
  1514          vid = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_ID]);
  1515          subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
  1516  
  1517          dev = nfc_get_device(dev_idx);
  1518          if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
  1519                  return -ENODEV;
  1520  
  1521          data = nla_data(info->attrs[NFC_ATTR_VENDOR_DATA]);
  1522          if (data) {
  1523                  data_len = nla_len(info->attrs[NFC_ATTR_VENDOR_DATA]);
  1524                  if (data_len == 0)
  1525                          return -EINVAL;
  1526          } else {
  1527                  data_len = 0;
  1528          }

nla_data() never returns NULL.  The test should probably be:

		if (info->attrs[NFC_ATTR_VENDOR_DATA]) {

Why is specifying data_len == 0 invalid?

  1529  
  1530          for (i = 0; i < dev->n_vendor_cmds; i++) {
  1531                  cmd = &dev->vendor_cmds[i];
  1532  
  1533                  if (cmd->vendor_id != vid || cmd->subcmd != subcmd)
  1534                          continue;
  1535  
  1536                  return cmd->doit(dev, data, data_len);
  1537          }
  1538  
  1539          return -EOPNOTSUPP;
  1540  }

regards,
dan carpenter
