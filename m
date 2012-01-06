Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:53085 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2AFFAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 00:00:06 -0500
Date: Thu, 5 Jan 2012 21:00:01 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Franky Lin" <frankyl@broadcom.com>
Cc: "Arend Van Spriel" <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] brcmfmac: use existing net_device_stats
Message-ID: <20120105210001.600aacd3@nehalam.linuxnetplumber.net> (sfid-20120106_060011_077811_148F3D63)
In-Reply-To: <4F05FC76.5070509@broadcom.com>
References: <20120105183947.295358582@vyatta.com>
	<20120105184000.572918423@vyatta.com>
	<4F05F60C.5030406@broadcom.com>
	<20120105111554.57f411d0@nehalam.linuxnetplumber.net>
	<4F05FC76.5070509@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Jan 2012 11:39:34 -0800
"Franky Lin" <frankyl@broadcom.com> wrote:

> On 01/05/2012 11:15 AM, Stephen Hemminger wrote:
> > On Thu, 5 Jan 2012 20:12:12 +0100
> > "Arend van Spriel"<arend@broadcom.com>  wrote:
> >
> >> On 01/05/2012 07:39 PM, Stephen Hemminger wrote:
> >>> Minor space savings. Compile tested only.
> >>>
> >>
> >> This is actually not going to work. The struct brcmf_if represents
> >> individual interfaces which each have their own device statistics.
> >>
> >
> > Why not, if you  look it is only used during the aggregation and return
> > of netdevice stats.
> >
> 
> We only support one primary interface at the moment. But we have plan to 
> add P2P support using virtual interfaces. It would be better to have 
> individual stats for different interfaces.
> 
> Thanks,
> Franky
> 

You are confused. The only place the data in question is used is:
static struct net_device_stats *brcmf_netdev_get_stats

This is a per-network device standard API and it returns per-network device
statistics. Several releases ago, structure element was added to the network_device
struct for common usage by drivers. All this patch does is use that instead of the
private device scratch pad.

If you really want to be more clever, the device should be convert to the
new getstats64 API, but that requires more work (like wrapping updates with
the u64_stats_sync() macros.
