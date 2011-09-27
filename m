Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49371 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1I0X3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 19:29:32 -0400
Received: by qyk30 with SMTP id 30so1645247qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 16:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6USxp0rGPP2NFkThCFzpSccZ7WUF7AfxJ=3js5Ph5D82g@mail.gmail.com>
References: <CAMxespA2quGEuN3B0CE2SJGeRLr5vgtfqQYVQ5r5Oxtj-paj2w@mail.gmail.com>
 <CAPjQAd-=ihu5ULzuyUjGQD3DKe2Tpi749esOi9nb1c-dW=5nSQ@mail.gmail.com>
 <CAMxespDxUdm1Qx+GGYzzfJ+jdUVw_nmZDcyeRV2HqmB=0LhtDg@mail.gmail.com> <CAB=NE6USxp0rGPP2NFkThCFzpSccZ7WUF7AfxJ=3js5Ph5D82g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Sep 2011 16:29:11 -0700
Message-ID: <CAB=NE6U-=6UZfMvtv5Z77PcRbZCmXrbveM4N0mzcqXAR0QtTAQ@mail.gmail.com> (sfid-20110928_012935_837503_289DA1F9)
Subject: =?UTF-8?Q?Re=3A_Channel_type_negotiation_=E2=80=93_HT_support_for_mesh?=
To: Ashok Nagarajan <anagar6@uic.edu>, thomas <thomas@cozybit.com>
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>,
	Sidharth Thakur <sidthakur@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 3:39 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Sep 27, 2011 at 1:49 AM, Ashok Nagarajan <anagar6@uic.edu> wrote:
>> In our previous conversation, Thomas was mentioning about very low
>> 802.11n rate and we din't have a clear reason for such low 11n rate!
>
> This may be WMM not being configured which is required for 802.11n, if
> you disable WMM on the AP <--> STA setup you may see the same poor
> performance.

So this is due to the fact that 802.11e which WMM requires is the
component of the spec that adds BlockAck support and therefore
Aggregation. You'll achieve higher throughput once you support
aggregation. I just reviewed with Thomas how we'd go about setting WMM
parameters and it seems we want to do this in cfg80211 at set channel.
This also bring up the question for IBSS as well and what to do when
your peer has different WMM parameters, this is not something you deal
with with infrastructure mode.

For now I would go with using default WMM parameters which the spec
does specify for both IBSS and Mesh and not peering up unless your
peer also beacons those same parameters. Later we can figure out how
we want to handle differences, maybe go with the minimum? The
difficulty with converging to values is although likely possible you
can also end up with races with different nodes on your network trying
to sych up with the same values.

For example, for IBSS we've already learned that if you do not want an
IBSS merge split you want to ensure to use the same SSID and BSSID. I
cannot be sure right now that any sort of similar splits may happen
with WMM / HT settings but just want to put that thought out there
before we support it. If we only support peering up with peers with
the same WMM capabilities at least we will not introduce issues, only
limitations with peers which can later be addressed if it addresses
properly all known mismatch issues.

Thomas is now looking at adding the WMM stuff for Mesh, the same will
be required for IBSS HT support.

A while back we had heard 802.11s support will *not* support
aggregation, Javier, did the spec go out like that? Why was
aggregation thought to not be possible with 802.11s? I can't see why
right now. If we want to do comparable throughput tests for HT rates
with Mesh we'd need to setup an AP with aggregation disabled, and the
same WMM parameters.

  Luis
