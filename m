Received: from mail.lysator.liu.se (mail.lysator.liu.se [130.236.254.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16921350298
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 22:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.236.254.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783982262; cv=none; b=dUbeAQhCoRks38xnjD8evI1f6WP99mCKJPO5Ozlx69ZsDgFqcXVrWFCns7AYs5C+bZA05KlN2I4upnzccekmr99LFbNDOZ9HSyGJK0YXNifjD/OObORI3YVGut7Uh0NtawwDY45QtJBVUqVfe6soQz8ji9hJRfFaRtQTMmZcGMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783982262; c=relaxed/simple;
	bh=a/ObstaEYmqKfmgI1pWt88Y8OFfJ7pm7jp6fwga5Sks=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=hFuZUu+MnjaHO62Aaiy6SfVTayh3M4sFUo5Zf2jszA/EBEs6KHG3ib/t2YYcRalEuUK497NyzuCALi7yZ47wuabS5SWLrSlgd5lv9HlKA7gV8VLc2lyW4B7p66UqdXYx44YGBlCBHXyJc3zveMRnA9u73D8sl8BSYxMToxR2IEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lysator.liu.se; spf=pass smtp.mailfrom=lysator.liu.se; dkim=pass (2048-bit key) header.d=lysator.liu.se header.i=@lysator.liu.se header.b=slzS1Px6; dkim=pass (2048-bit key) header.d=lysator.liu.se header.i=@lysator.liu.se header.b=slzS1Px6; dkim=pass (2048-bit key) header.d=lysator.liu.se header.i=@lysator.liu.se header.b=TOdAUHj5; arc=none smtp.client-ip=130.236.254.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lysator.liu.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lysator.liu.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lysator.liu.se header.i=@lysator.liu.se header.b="slzS1Px6";
	dkim=pass (2048-bit key) header.d=lysator.liu.se header.i=@lysator.liu.se header.b="slzS1Px6";
	dkim=pass (2048-bit key) header.d=lysator.liu.se header.i=@lysator.liu.se header.b="TOdAUHj5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lysator.liu.se;
	s=2026; t=1783982256;
	bh=a/ObstaEYmqKfmgI1pWt88Y8OFfJ7pm7jp6fwga5Sks=;
	h=Date:From:To:Subject:From;
	b=slzS1Px6Ob65AQ0DFK1hzWOfHItJtGB3FsC8FNPmzSswrPX03n+uUCDSFuHlXAtN4
	 OZ1o/g12NnFBLWSRJR7DbqA6YWrOFfme4ZPwOuiCLHf91yDT1HwnHdae777ze+sGNS
	 Z7XgWSATFNAjaqZ2LccZNZ3MnRcIvc7mp1JX/8LiA3htmj1cjCBcPyKCksM7Y3WuM2
	 uHFznnTD6/aAVPowzmJ/P5MvZ6JdCnt5UJmCmMwlyBv3aSupmOC0ec+F3hzsDEiaie
	 BNm5/OEZPUSCang2NkUbT0G6XfXRAANiUbJkiDN2vCWv2xSZsU3F0xKW7DkF9G2qV1
	 kNAJnRN4daWyg==
Received: from mail.lysator.liu.se (localhost [127.0.0.1])
	by mail.lysator.liu.se (Postfix) with ESMTP id A053B643E
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 00:37:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lysator.liu.se;
	s=2026; t=1783982256;
	bh=a/ObstaEYmqKfmgI1pWt88Y8OFfJ7pm7jp6fwga5Sks=;
	h=Date:From:To:Subject:From;
	b=slzS1Px6Ob65AQ0DFK1hzWOfHItJtGB3FsC8FNPmzSswrPX03n+uUCDSFuHlXAtN4
	 OZ1o/g12NnFBLWSRJR7DbqA6YWrOFfme4ZPwOuiCLHf91yDT1HwnHdae777ze+sGNS
	 Z7XgWSATFNAjaqZ2LccZNZ3MnRcIvc7mp1JX/8LiA3htmj1cjCBcPyKCksM7Y3WuM2
	 uHFznnTD6/aAVPowzmJ/P5MvZ6JdCnt5UJmCmMwlyBv3aSupmOC0ec+F3hzsDEiaie
	 BNm5/OEZPUSCang2NkUbT0G6XfXRAANiUbJkiDN2vCWv2xSZsU3F0xKW7DkF9G2qV1
	 kNAJnRN4daWyg==
Received: by mail.lysator.liu.se (Postfix, from userid 1004)
	id 8715D643D; Tue, 14 Jul 2026 00:37:36 +0200 (CEST)
X-Spam-Level: 
X-Spam-Score: -1.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lysator.liu.se;
	s=2026; t=1783982255;
	bh=a/ObstaEYmqKfmgI1pWt88Y8OFfJ7pm7jp6fwga5Sks=;
	h=Date:From:To:Subject:From;
	b=TOdAUHj5u/31/OdsZNQPeWNcX/l3bAKQowXn8g6ZbnNJgyD60wzNcsoMxnwDyf2f2
	 cvQPUyWyUyTWet0NM+K0bvVkeAVmvIFyu9beLYxa9F0/iMRnGlCildC2NXOP1pfJcr
	 pkRicPO17OtOR1QnupVsH3nqt6+sXz/260/GqOIv2tZgX+X7zzsTV/NpsevnTFXN6r
	 4/13LlMSUniEWz8voK9HbVNOFzRvp16J84KmJTaFQ7dMAde7CGwF72VbFQZn6Z+Iw3
	 l+Ap9XQXWrjs7s1Ey5WAfEjxSKgbsjrlU8ipQhf01E8p/c7oq3ub6aLXAVxa1GeETW
	 TIkY/23LkA6Mw==
Received: from sara (unknown [IPv6:2001:9b1:efc:9600:b23a:23f5:df9b:ee0d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.lysator.liu.se (Postfix) with ESMTPSA id 00F0F64BC
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 00:37:34 +0200 (CEST)
Date: Tue, 14 Jul 2026 00:37:34 +0200 (CEST)
From: Peter Astrand <astrand@lysator.liu.se>
To: linux-wireless@vger.kernel.org
Subject: iw scan hangs in netlink ENOBUFS loop with kernel 6.6.99+
Message-ID: <19b022d0-76ff-23cc-ba63-f00fedc65ed1@lysator.liu.se>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Virus-Scanned: ClamAV using ClamSMTP


kernel 6.6.y
iw 6.7
libnl-genl-3-200 3.9.0
mac80211_hwsim

With kernel 6.6.99 and later, "iw dev <device> scan" sometimes hangs in 
busy loop:

recvmsg(3, {msg_namelen=12}, 0)         = -1 ENOBUFS (No buffer space available)
recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, 
msg_namelen=12, msg_iov=[{iov_base=[{nlmsg_len=48, nlmsg_type=NLMSG_ERROR, 
nlmsg_flags=0, nlmsg_seq=2511084235, nlmsg_pid=-1866444344}, 
{error=-ENOBUFS, msg=[{nlmsg_len=28, nlmsg_type=0x18 /* NLMSG_??? */, 
nlmsg_flags=NLM_F_REQUEST|NLM_F_ACK|0x300, nlmsg_seq=2511084235, 
nlmsg_pid=-1866444344}, 
"\x20\x00\x00\x00\x08\x00\x03\x00\x0e\x00\x00\x00"]}], iov_len=16384}], 
msg_iovlen=1, msg_controllen=0, msg_flags=0}, MSG_PEEK|MSG_TRUNC) = 48

This issue appears with kernel 6.6.99 and later, even latest version 
6.6.144. 

If I revert these commits:

346c820ef513 netlink: avoid infinite retry looping in netlink_unicast()
c31ee1695b6d netlink: make sure we allow at least one dump skb
ce2ac2e46719 netlink: Fix rmem check in netlink_broadcast_deliver().
55baecb9eb90 netlink: Fix wraparounds of sk->sk_rmem_alloc.

...then 6.6.144 works fine as well. Seems like there is a regression here. 
Any ideas? 

Br,
Peter Astrand

