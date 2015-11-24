Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48491 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbbKXOil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 09:38:41 -0500
Date: Tue, 24 Nov 2015 17:38:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bzhao@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: wireless: mwifiex: initial commit for Marvell mwifiex driver
Message-ID: <20151124143826.GA9360@mwanda> (sfid-20151124_153846_185773_AFF3AFA8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Bing Zhao,

The patch 5e6e3a92b9a4: "wireless: mwifiex: initial commit for
Marvell mwifiex driver" from Mar 21, 2011, leads to the following
static checker warning:

	drivers/net/wireless/marvell/mwifiex/sta_cmd.c:133 mwifiex_cmd_802_11_snmp_mib()
	warn: potential memory corrupting cast 2 vs 1 bytes

drivers/net/wireless/marvell/mwifiex/sta_cmd.c
   112  static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
   113                                         struct host_cmd_ds_command *cmd,
   114                                         u16 cmd_action, u32 cmd_oid,
   115                                         u16 *ul_temp)
   116  {
   117          struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
   118  
   119          mwifiex_dbg(priv->adapter, CMD,
   120                      "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
   121          cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
   122          cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
   123                                  - 1 + S_DS_GEN);
   124  
   125          snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
   126          if (cmd_action == HostCmd_ACT_GEN_GET) {
   127                  snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_GET);
   128                  snmp_mib->buf_size = cpu_to_le16(MAX_SNMP_BUF_SIZE);
   129                  le16_add_cpu(&cmd->size, MAX_SNMP_BUF_SIZE);
   130          } else if (cmd_action == HostCmd_ACT_GEN_SET) {
   131                  snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
   132                  snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
   133                  *((__le16 *) (snmp_mib->value)) = cpu_to_le16(*ul_temp);
                                      ^^^^^^^^^^^^^^^
We're writing two bytes here but it's only a 1 byte array.  It's a
__packed array as well so there isn't any padding.

   134                  le16_add_cpu(&cmd->size, sizeof(u16));
   135          }
   136  
   137          mwifiex_dbg(priv->adapter, CMD,
   138                      "cmd: SNMP_CMD: Action=0x%x, OID=0x%x,\t"
   139                      "OIDSize=0x%x, Value=0x%x\n",
   140                      cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
   141                      le16_to_cpu(*(__le16 *)snmp_mib->value));
   142          return 0;
   143  }



regards,
dan carpenter
