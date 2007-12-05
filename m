Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbXLERMT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 12:12:19 -0500
Subject: Re: [PATCH 0/5] libertas: allow easier command playing
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200712051757.52053.hs4233@mail.mn-solutions.de>
References: <200712051757.52053.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 12:06:48 -0500
Message-Id: <1196874408.12263.9.camel@localhost.localdomain> (sfid-20071205_171226_082794_10841E6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-12-05 at 17:57 +0100, Holger Schurig wrote:
> I'll want to investigate the behavior of my libertas CF card
> firmware, e.g. to decide if I can use the background scan feature
> of the card or not.

Yeah; need to get this figured out with David; he'll probably start
yelling loudly if these get acked.  He might be committing/reverting
locally and just not pushing up to libertas-2.6 until he's ready.
However, he did promise something by Friday.  I'd almost say push your
patches to libertas-2.6 and let Woodhouse handle the merge work when he
pulls from the repo, but he'll probably have a better idea.

Dan

> Unfortunately, currently the firmware command execution is spread
> over several files, e.g. hostcmd.h, host.h, types.h, cmd.c,
> cmdresp.c and sometimes even other files. Add two very large
> switch() statements, a structure with a union of about 60 structs
> and misc functions at other places (do a "grep -l lbs_cmd_ *.c" to
> find out).
> 
> It's not really easy to just-write-a-test for a specific firmware
> command.
> 
> So I made a new function, lbs_cmd(), that is an easier substitute
> for subset of possible lbs_prepare_and_send_command(). I know
> that this might clash with David Woodhouse's cmd-cleanup
> attempt, but it seems that he didn't start yet, as my patches
> still apply to his git tree :-)   I didn't commit them there,
> because I'm confused if my patches go upstream via David or John.
> 
> 
> Usage example
> -------------
> When I want to deal with the CMD_802_11_BG_SCAN_QUERY command, I
> can now put all the code at one place to test it:
> 
> 
> // This is from firmware manual, Appendix A
> #define CMD_802_11_BG_SCAN_QUERY 0x006c
> 
> // This is from firmware manual, section 5.7.3:
> struct cmd_scan_query {
>         u8 flush;
> };
> struct cmd_bg_scan_query_rsp {
>         __le32 report_cond;
>         __le16 bss_size;
>         u8 num_sets;
>         u8 bss[0];
> };
> 
> // Allocate space for command response
> int rsp_size = sizeof(struct cmd_bg_scan_query_rsp) + 1024;
> struct cmd_bg_scan_query_rsp *rsp = kzalloc(rsp_size, GFP_KERNEL);
> 
> // "Allocate" space for the command itself
> struct cmd_bg_scan_query cmd;
> cmd.flush = 0;
> 
> // Send command and use result:
> res = lbs_cmd(priv, CMD_802_11_BG_SCAN_QUERY, &cmd, sizeof(cmd), rsp, &rsp_size);
> if (res == 0)
>         printk("num_sets %d, resp_size %d\n", resp->num_sets, resp_size);
> 
> 
> 
> Some notes:
> 
> a) the cmd structs no longer need or care for the 4 common
>    fields (command, size, seqnum, result)
> b) resp_size must be a pointer to an int, because some
>    firmware functions return a variable amount of bytes and
>    we need to know how much bytes that might be
> c) however, if you just get a fixed response (or the beginning
>    of your response has fixed fields), you can simply use
>    resp->(whatever field you want> to access it
> d) from 69 calls to lbs_prepare_and_send_command() 56 use
>    CMD_OPTION_WAITFORRSP. So my first stab was using this.
>    However, it would be possible to add a function pointer
>    argument to lbs_cmd(), which could be called asynchronously
>    if the result is there. A lbs_cmd_noop() could the be
>    used for commands where one don't need the callback.
> 
> The lbs_cmd() function could not only used while prototyping
> (as I need it), but also to slowly rewrite much of the ugly
> cmd.c / cmdresp.c code into an simpler way.
> 
> 
> In this patchset are also some cleanup patches. They depend
> on a patch that David Woodhouse has in his tree, but that isn't
> yet in wireless-2.6/everything. I've added this patch to the
> patch series as well.

