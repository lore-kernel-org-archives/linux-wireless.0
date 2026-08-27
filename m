Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12726366567
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 01:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787793862; cv=none; b=iPoUr6p/6yFJ7wOw35y/xCBe1ak1EW8yyBtFV+3fmB+houKY6KP4N6fkVkMF/MqhmaxNionr5pHKspdwwfM3J0lLcCLAB5v6eYvldGUiVR4GWmHtTaUj3Evy7o03VygOv63CvsgwF2eewL7LRSHXymQCZgrcOTMXVosmA4/3NaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787793862; c=relaxed/simple;
	bh=n5MyuTScv6wA5T78EY70uekJ0jWe3IYyMcz1KjEJrPo=;
	h=From:Message-ID:Date:Subject:To:MIME-Version:Content-Type; b=lT3mLC70oEc4j8XM57ZmDVVobRhUVecMrFZU7HVswMrVCGvoeQzSCW+HY+yP/hwFhR2EuuBS8bZEAtJJ7ZFZFAKm+guqr0kDxfuN6qooVNfh1qB79Bn5B9a4Zm6zG3fMDaZyhSaw7hScQ+moumNnAig0R6CB46xJI1yGRyFhnwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=bZUOIyRd; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=dQMwgbPO; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="bZUOIyRd";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="dQMwgbPO"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787793860; x=1788398660; bh=R8agjWfYY2oYlUhImh
	VsejiTu0JFw9qNn6R1p25lThc=; b=bZUOIyRdyQvRRoGy3MwDbXcIez4fu5S56kcZQlQGvpO8C
	bJIuaLE3OCs2JrOjFI4/easzNv4iaTJq4Lob3xuYz6KrRXsf22Ys/39ChcDnMJ9yF5keKmo1Aug
	HXAppH+lGZ0mqkqtfwZOJYkhnNL51lsU/Q6JfOggzudEW+wHFONSQPI/dozwuXY41ogImXOiwZj
	baqkuKyThzIJ4j16o4k5LiCyWfiVrIvicfn2gSgiT4m8rkGxytT6MtawfhLJrKjHINH2mkDu+1F
	wiqQ0KOx3mhQtNOaH65y/DDSVzSvENB1TT7lTHEti+TXLMzui0RMpTyqqWCkatg09OVdf/VQ==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787793860; x=1788398660; bh=R8agjWfYY2oYlUhImh
	VsejiTu0JFw9qNn6R1p25lThc=; b=dQMwgbPOyRALSaTON8TeS5s83VmsItG9QyNxmSNLcrg//
	JkOzqQhndA+uT29QQSVyfOfV3rjCffyn+HOy3NUN8KG/qCD4EV0vgVApXbpUVpju1lwaYmZ4FlA
	Ts1RfixI2g5szk58duHX9UpGIFdsvZRKpepQs8Aw3bZc8DQ526gtxnHZVmeLoRNblQLTjJ6Dtxu
	uenWSZF4AeS5nkbo1jUjjrfU7G5gExmDS4m8bGr6rom89JnLWh3F0CbKA/gLVqkq9W0ai59Sft6
	8AYM+UdfEYFrFQJoeMt8ktZDlWGGWrJkwnxn3kEfhcwmI6VdDMXwkJzDkZ7rQoUuUx0Pg1Xg==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+36935f8953d6874a@bugs.sh>
Message-ID: <s6BRFbJoyNpjUBu6NC9TdJxvXM9vpQsN1FcY@bugs.sh>
Date: Thu, 27 Aug 2026 01:24:09 +0000
Subject: [BUG] net/mac80211: use-after-free in ieee80211_remove_link_keys()
To: linux-wireless@vger.kernel.org, "Johannes Berg" <johannes@sipsolutions.net>, "Ilan
 Peer" <ilan.peer@intel.com>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We found a bug reachable in:

    path    net/mac80211
    crash   use-after-free in ieee80211_remove_link_keys()
    commit  53d3c6ddbb97 ("Linux 6.12.62")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you patch the bug based on our artifacts, a tag would be
    appreciated:

Reported-by: co+36935f8953d6874a@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an LLM-generated root-cause analysis and a candidate
    patch. The patch passes an A/B test: the same reproducer panics the
    unpatched kernel and runs clean on the patched one. Neither has had
    human review, so both still require validation before you send or
    apply them. Available on:

        patch.diff  https://bugs.sh/b/36935f8953d6874a/patch.diff
        report.md   https://bugs.sh/b/36935f8953d6874a/report.md

    This is an open science project. The code and the full set of PoCs
    are not public at this moment, as we intend to disclose our findings
    in an ethical way.

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  53d3c6ddbb97 ("Linux 6.12.62")
    VM setup       https://bugs.sh/b/36935f8953d6874a/run.sh
    config         https://bugs.sh/b/36935f8953d6874a/config.gz
    poc            https://bugs.sh/b/36935f8953d6874a/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in ieee80211_remove_link_keys (net/mac80211=
/key.c:1114)
Read of size 8 at addr ffff888028c3c818 by task exploit/5192
CPU: 1 UID: 65534 PID: 5192 Comm: exploit Not tainted 6.12.62 #3
Call Trace:
dump_stack_lvl (lib/dump_stack.c:123)
print_report (mm/kasan/report.c:378 mm/kasan/report.c:481)
kasan_report (mm/kasan/report.c:596)
ieee80211_remove_link_keys (net/mac80211/key.c:1114)
ieee80211_vif_update_links (net/mac80211/link.c:192 net/mac80211/link.c:351)
ieee80211_vif_set_links (net/mac80211/link.c:408)
cfg80211_remove_link (arch/x86/include/asm/jump_label.h:27 include/linux/ju=
mp_label.h:207 net/wireless/trace.h:425 net/wireless/rdev-ops.h:1460 net/wi=
reless/util.c:2894)
nl80211_remove_link (net/wireless/nl80211.c:16312)
genl_family_rcv_msg_doit (net/netlink/genetlink.c:1117)
genl_rcv_msg (net/netlink/genetlink.c:1195 net/netlink/genetlink.c:1210)
netlink_rcv_skb (net/netlink/af_netlink.c:2546)
genl_rcv (net/netlink/genetlink.c:1220)
netlink_unicast (net/netlink/af_netlink.c:1314 net/netlink/af_netlink.c:133=
9)
netlink_sendmsg (net/netlink/af_netlink.c:1889)
__sys_sendto (net/socket.c:729 (discriminator 1) net/socket.c:744 (discrimi=
nator 1) net/socket.c:2214 (discriminator 1))
__x64_sys_sendto (net/socket.c:2222)
do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/=
common.c:83 (discriminator 1))
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
Allocated by task 5192:
Freed by task 5192:
The buggy address belongs to the object at ffff888028c3c800
which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 24 bytes inside of
freed 1024-byte region [ffff888028c3c800, ffff888028c3cc00)
The buggy address belongs to the physical page:
Kernel panic - not syncing: KASAN: panic_on_warn set ...


---
The report format is based on syzbot bug report.

This report is generated by a bot. It may contain errors.
See https://github.com/n132/cedalion for more information.

For any issue with this report, reach out to cedalion@bugs.sh

If the report is already addressed, let us know by replying with:
#co fix: <commit hash>

If the report is a duplicate of another one, reply with:
#co dup: <lore link>

If you want to undo deduplication, reply with:
#co undup


