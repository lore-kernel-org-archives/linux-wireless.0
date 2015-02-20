Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44041 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbbBTP6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 10:58:01 -0500
MIME-Version: 1.0
In-Reply-To: <54E74C8F.9020606@gmail.com>
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
 <20150206235802.GA19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D01068E@HASMSX106.ger.corp.intel.com>
 <20150210200027.GG19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D017CEB@HASMSX106.ger.corp.intel.com>
 <20150220005344.GF20824@wotan.suse.de> <36119.1424394185@turing-police.cc.vt.edu>
 <54E74C8F.9020606@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 20 Feb 2015 07:57:39 -0800
Message-ID: <CAB=NE6XOvkCjBY=bqDPMFjE2u3kwfjmHDYe_aXnoC3tFZxOgXA@mail.gmail.com> (sfid-20150220_165806_074245_AD443E48)
Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor regulatory setting
To: Jonathan Bither <jonbither@gmail.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2015 at 7:02 AM, Jonathan Bither <jonbither@gmail.com> wrote:
> On 02/19/2015 08:03 PM, Valdis.Kletnieks@vt.edu wrote:
>>
>> On Fri, 20 Feb 2015 01:53:44 +0100, "Luis R. Rodriguez" said:
>>>
>>> Wider community:
>>>
>>> anyone aware of any *need* in the kernel to know whether one is indoor or
>>> not on a device running Linux other than wifi? Clearly it should be
>>> something
>>> that might be of interest to at least other RF devices, so that is at
>>> least
>>> one possibilty to consider already, but what else?
>>
>>
>> I can think of a lot of reasons for the kernel to make indoor/outdoor
>> status available to userspace, but am coming up empty why the kernel
>> itself
>> should care....
>>
> That made me try to think of the possible uses for such a variable but I
> imagine that they can all be handled by userspace as well.
>         Powering down GPS chips for energy consumption.
>         Applying filters to cameras for fluorescent lights.

These days such devices are bundled with all these devices typically
aiming towards single-chip, ie one devices with multiple functions and
sharing as much as possible, as such it should be possible
architecturally to share this. So far then it seems this can just live
under its hood under cfg80211 then.

 Luis
