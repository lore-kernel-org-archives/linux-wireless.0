Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35269 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbbDILCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 07:02:18 -0400
Received: by widdi4 with SMTP id di4so87597218wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2015 04:02:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150409073525.GA21000@w1.fi>
References: <1428422722-655-1-git-send-email-ilan.peer@intel.com>
 <552400F4.5010701@candelatech.com> <CB3B3D4774441E42AA3EA0E1BA8230A04D09BD1B@HASMSX106.ger.corp.intel.com>
 <20150409073525.GA21000@w1.fi>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 9 Apr 2015 16:31:57 +0530
Message-ID: <CABPxzYKh2y8n8oqyYUmVH7UvGPhk0AuNcC2ruwcb6CWZoL1+qg@mail.gmail.com> (sfid-20150409_130225_707275_04CA9630)
Subject: Re: [PATCH 1/2] mac80211_hwsim: Set VHT capabilities only for the 5.2
 GHz band
To: Jouni Malinen <j@w1.fi>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 9, 2015 at 1:05 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Apr 08, 2015 at 06:29:38PM +0000, Peer, Ilan wrote:
>> According to the 802.11ac amendment: "The IEEE 802.11 VHT STA operates in frequency bands below 6 GHz excluding the 2.4 GHz band", so at least the spec. is clear about it. However, I guess it would be possible to enable VHT for 2.4 as well to enjoy some of benefits, but do you see a reason/use case to enable it also for hwsim?
>
> It does not matter what the standard says on VHT in general; there are
> clearly already products out there that allow some capabilities defined
> in 802.11ac (mainly, 256-QAM) to be used on the 2.4 GHz band.
Can you name a few for reference?
>As far as
> hwsim is concerned, I'm already using it to verify the negotiation part
> for this (see ap_vht_on_24ghz test case). The main remaining question
> for cfg80211/nl80211 is on whether we can come up with a clean way of
> advertising driver capability for doing this.
In order to properly utilize these we need to incorporate these capabilities
 in to minstrel RC as well. Any plans for that?
