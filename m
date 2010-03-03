Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab0CCGYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 01:24:16 -0500
Date: Wed, 3 Mar 2010 07:24:00 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	tcpdump-workers@lists.tcpdump.org
Subject: Re: Current wireless-testing breaks libpcap: mr_alen should be set
Message-ID: <20100303062359.GA2648@psychotron.redhat.com>
References: <1267578048.14049.11.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1267578048.14049.11.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Mar 03, 2010 at 02:00:48AM CET, proski@gnu.org wrote:
>Hello!
>
>The current wireless-testing appears to have some non-wireless bits from
>the upcoming Linux 2.6.34.  As a result, libpcap and all capture
>programs that use it are broken.
>
>This patch to libpcap helps:
>
>--- a/pcap-linux.c
>+++ b/pcap-linux.c
>@@ -1563,6 +1563,7 @@ live_open_new(pcap_t *handle, const char
> 			memset(&mr, 0, sizeof(mr));
> 			mr.mr_ifindex = handle->md.ifindex;
> 			mr.mr_type    = PACKET_MR_PROMISC;
>+			mr.mr_alen    = 6;
> 			if (setsockopt(sock_fd, SOL_PACKET,
> 				PACKET_ADD_MEMBERSHIP, &mr, sizeof(mr)) == -1)
> 			{
>
>libpcap git doesn't have the fix yet.
>
>The breakage must be coming from the commit 914c8ad2 by Jiri Pirko to
>net/packet/af_packet.c
>
>I think it's very unhelpful to introduce patches that break significant
>userspace functionality without giving the affected programs an advance
>warning.
>
>Also, pulling bleeding edge stuff into wireless-testing before rc1
>appears to be either a mistake or a bad decision.
>
>Sorry for cross-post, but it's an urgent issue.  Repliers are encouraged
>to trim the recipient list as necessary.

Sorry about this. Corrected patch will follow.

Jirka
>
>-- 
>Regards,
>Pavel Roskin
