Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F901309F09;
	Wed, 11 Mar 2026 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773237822; cv=none; b=U7cF4nZxtc2c4cK7n1OzG19aH5+dgU9f/wqLQSvQgb4j7iZp4rSBbttgdWd97z8mI7ozV0nJMXb06lND7uHMcqLkpZED3/t+en8Br7LrsV1Yo9jLZDnvosBfQBUyYa1MgbXFRK5K38pcBBbNEMwSK75/oRI2MSAFzxbbIIa4Gw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773237822; c=relaxed/simple;
	bh=Co6af1PDO/5BNnOq+gUEX5fdYaHwA4r9elfY/kzPOJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qyBMsrb5SPFBIIc854cuwDhH3Ipf4a1siEqNW06kPLlIONuEYGb0ab2B91Z7WgCJv0P/LMiDdAGxS5RQO+hPu4o/F5B0FSlaf1WkURBKFXIEAErUTT1WageYMo0IOYuda3GtC8L+q+16QjVqBE2K1Ac2uV/+XuLSwNcT1IiHmi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53D96B6D37;
	Wed, 11 Mar 2026 14:03:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 0CF3220025;
	Wed, 11 Mar 2026 14:03:20 +0000 (UTC)
Date: Wed, 11 Mar 2026 10:03:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL
 check
Message-ID: <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311141332.b611237d36b61b2409e66cb3@kernel.org>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	<20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de>
	<20260310100750.303af303@gandalf.local.home>
	<20260311141332.b611237d36b61b2409e66cb3@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0CF3220025
X-Stat-Signature: ff8ct3tumfmuryqygkfkcm78w16u4scc
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+skqrXXDxm4il2tsYmj25H0/GTzSRdMUI=
X-HE-Tag: 1773237800-364001
X-HE-Meta: U2FsdGVkX1+aU4mY7bFvO8lRauP/vgjT20dobHa0QHVROVhTP6xZNvlHFy+HnthX7C3DUw86Ksayk8kipkioUde1pGRJffeDzlmGTmiRQAtxOhSsM3gHnZJQZGdgNXBABYZdeE7OsMEvCI5Ff4ZQbbyu3yXHRyZXg5AHof/AO0vcusmeqjpCWWhtLLOcuZIY7+tOVjT7VktVnLaFPp1jjRLc3JQ2sJ4jp/SiL4aHgDK/k//b9d34oAYT+AlJT32Fm0BFv3eObF3U3OAnj7CnGXu0MyQ+0edSgYKqKIiOybnUsF1fYSODF4X+zk3bqwV4HOqJnRMkZevrGktYEsiiqb8/qNY0d6MZ

On Wed, 11 Mar 2026 14:13:32 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> 
> node = rhashtable_walk_next(&iter);
> while (!IS_ERR_OR_NULL(node)) {
> 	fprobe_remove_node_in_module(mod, node, &alist);
> 	node = rhashtable_walk_next(&iter);
> }

But now you need to have a duplicate code in order to acquire "node"

I think the patch just makes the code worse.

-- Steve
