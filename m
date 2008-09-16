Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50116 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYIPVtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 17:49:02 -0400
Subject: Re: iw packaging
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221601136.9262.23.camel@johannes.berg>
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221598208.17084.11.camel@dv>  <1221599460.9262.16.camel@johannes.berg>
	 (sfid-20080916_231152_167035_625A9793)  <1221599757.9262.19.camel@johannes.berg>
	 <1221600232.17084.16.camel@dv>  <1221601136.9262.23.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 17:48:59 -0400
Message-Id: <1221601739.17084.22.camel@dv> (sfid-20080916_234907_186069_1A0FD3BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 23:38 +0200, Johannes Berg wrote:

> I think what may be happening is that alignment is somehow messing
> things up. Can you please try the patch below?

The patch doesn't help:

$ ./iw 
Usage:  ./iw [options] command
Options:
        --debug         enable netlink debugging
        --version       show version
Commands:
        list
        Segmentation fault (core dumped)

(gdb) p __start___cmd
$1 = 0x403d20
(gdb) p *__start___cmd
$2 = {section = 0x0, name = 0x403865 "list", args = 0x0, cmd = NL80211_CMD_GET_WIPHY, 
  nl_msg_flags = 768, idby = CIB_NONE, handler = 0x401da0 <handle_info>}
(gdb) p __start___cmd[0]
$3 = {section = 0x0, name = 0x403865 "list", args = 0x0, cmd = NL80211_CMD_GET_WIPHY, 
  nl_msg_flags = 768, idby = CIB_NONE, handler = 0x401da0 <handle_info>}
(gdb) p __start___cmd[1]
$4 = {section = 0x0, name = 0x0, args = 0x0, cmd = 4208746, nl_msg_flags = 0, idby = CIB_NONE, 
  handler = 0x1}
(gdb) p &__start___cmd[0]
$5 = (struct cmd *) 0x403d20
(gdb) p &__start___cmd[1]
$6 = (struct cmd *) 0x403d50

$ nm iw | grep __cmd |sort
0000000000403d20 A __start___cmd
0000000000403d20 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_NONE
0000000000403d60 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_PHY
0000000000403da0 r __cmd_handle_nameNL80211_CMD_SET_WIPHYCIB_PHY
...

The next command is at 0x403d60, but the code expects it at 0x403d50.
gdb confirms it:

(gdb) p *(struct cmd *) 0x403d60
$1 = {section = 0x0, name = 0x40386a "info", args = 0x0, cmd = NL80211_CMD_GET_WIPHY, 
  nl_msg_flags = 0, idby = CIB_PHY, handler = 0x401da0 <handle_info>}
(gdb) p *(struct cmd *) 0x403da0
$2 = {section = 0x403878 "set", name = 0x40387c "name", args = 0x403881 "<new name>", 
  cmd = NL80211_CMD_SET_WIPHY, nl_msg_flags = 0, idby = CIB_PHY, 
  handler = 0x402230 <handle_name>}
(gdb)

-- 
Regards,
Pavel Roskin
