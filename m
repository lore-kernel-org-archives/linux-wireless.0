Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43912 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYIPUuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:50:10 -0400
Subject: Re: iw packaging
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221596962.9262.12.camel@johannes.berg>
References: <1221596962.9262.12.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:50:08 -0400
Message-Id: <1221598208.17084.11.camel@dv> (sfid-20080916_225015_099672_595F0E11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 22:29 +0200, Johannes Berg wrote:
> Hi,
> 
> I've just tagged iw version 0.9 (and 0.9.1 after a small build fix)
> because I think the tool is now actually usable in a limited way, unlike
> before where it would never properly report errors etc.
> 
> Anyone want to pick it up for the various distros?

Sorry for diverting the thread, but the current git head (which is
tagged as 0.9.1) is broken.

$ ./iw 
Usage:  ./iw [options] command
Options:
        --debug         enable netlink debugging
        --version       show version
Commands:
        list
        Segmentation fault (core dumped)

Debugging shows:

82              fprintf(stderr, "Commands:\n");
(gdb) 
Commands:
83              for (cmd = &__start___cmd; cmd < &__stop___cmd; cmd++) {
(gdb) p __start___cmd
$1 = {section = 0x0, name = 0x403d02 "info", args = 0x0, cmd = NL80211_CMD_GET_WIPHY, 
  nl_msg_flags = 0, idby = CIB_PHY, handler = 0x402403 <handle_info>}
(gdb) p *(&__start___cmd + 1)
$2 = {section = 0x0, name = 0x0, args = 0x0, cmd = 4209927, nl_msg_flags = 0, idby = CIB_NONE, 
  handler = 0x30000000001}
(gdb)

That means, __start___cmd points to "info".  The next command has no
name (and appears to be a complete mess).  The clever section trick
doesn't seem to work properly.

I'm using Fedora 9 x86_64 with all updates.

-- 
Regards,
Pavel Roskin
