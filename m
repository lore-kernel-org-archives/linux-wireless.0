Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1807 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab2AFUIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 15:08:00 -0500
Message-ID: <4F075497.9070607@broadcom.com> (sfid-20120106_210805_762579_3BBBC482)
Date: Fri, 6 Jan 2012 12:07:51 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Stephen Hemminger" <shemminger@vyatta.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] brcmfmac: use existing net_device_stats
References: <20120105183947.295358582@vyatta.com>
 <20120105184000.572918423@vyatta.com> <4F05F60C.5030406@broadcom.com>
 <20120105111554.57f411d0@nehalam.linuxnetplumber.net>
 <4F05FC76.5070509@broadcom.com>
 <20120105210001.600aacd3@nehalam.linuxnetplumber.net>
In-Reply-To: <20120105210001.600aacd3@nehalam.linuxnetplumber.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2012 09:00 PM, Stephen Hemminger wrote:
> You are confused. The only place the data in question is used is:
> static struct net_device_stats *brcmf_netdev_get_stats
>
> This is a per-network device standard API and it returns per-network device
> statistics. Several releases ago, structure element was added to the network_device
> struct for common usage by drivers. All this patch does is use that instead of the
> private device scratch pad.
>
> If you really want to be more clever, the device should be convert to the
> new getstats64 API, but that requires more work (like wrapping updates with
> the u64_stats_sync() macros.
>

I misunderstood since the first mail I got of this thread is Arend's 
reply. But I did receive the "brcmf: make net_device_ops const" patch. 
Something wrong with the mail server?

Franky

