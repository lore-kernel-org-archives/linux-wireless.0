Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35425 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbcGGJaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 05:30:15 -0400
Received: by mail-vk0-f52.google.com with SMTP id v6so12944249vkb.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2016 02:30:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467111448.2493.15.camel@sipsolutions.net>
References: <1462430663-9448-1-git-send-email-wnhuang@chromium.org>
 <1462464478.23962.12.camel@redhat.com> <CABicQ-VWrRG+0rEEF0GxUTPixSbkA18Gq4b5hbgph60SoEQ+2Q@mail.gmail.com>
 <CABicQ-XWm=Rxdj3at4+-0OAWn=T7qOTWEaTK=JY7LDOmcN87yw@mail.gmail.com>
 <1462991620.22404.5.camel@redhat.com> <CABicQ-UeU-8PPdK9Je51j_KD-BH8G1HuOjo0yZLcNBQgtJsyTA@mail.gmail.com>
 <1467111448.2493.15.camel@sipsolutions.net>
From: Wei-Ning Huang <wnhuang@google.com>
Date: Thu, 7 Jul 2016 17:30:13 +0800
Message-ID: <CABicQ-VVhNwbL6BxsTHa2xhEsgVCpudv9+uLO=PngBBZ+VvDYQ@mail.gmail.com> (sfid-20160707_113106_331469_41D3528A)
Subject: Re: [PATCH] cfg80211/nl80211: add wifi tx power mode switching support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	Linux-Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Sameer Nanda <snanda@chromium.org>,
	Todd Broch <tbroch@chromium.org>, davem@davemloft.net,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the reply.

You are right that the physical antenna does not change.
When I refer to 'calibration data', it actually corresponding to how
mwifiex adjust the per-band tx power. For mwifiex, the per-band tx
power is pre-calculated based on need, and stored in DT, a vendor
command or std nl80211 message is sent
to tell the driver to switch between two set of "calibration data".
I'm aware that iwl7000 is using a vendor command to do this as well,
but instead of pre-calculate required tx power info, the tx value can
be passed along with the vendor command message.

This patch was sent originally to standardize the requirement of
sending a vendor command to the driver (so it'll be a standard nl80211
message). However, we have decided to move along with vendor command
for both mwifiex and nl80211, so this patch is not needed anymore.
Thanks for the comments!

Wei-Ning

On Tue, Jun 28, 2016 at 6:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2016-05-12 at 17:34 +0800, Wei-Ning Huang wrote:
>>
>> Johannes, I feel like being able to set calibration data at runtime
>> is something common to all wireless drivers, so instead of using
>> vendor commands what do you think if I pass the calibration data name
>> instead of using those magic constants? This way, userspace does not
>> need to know the details of what band/range power limit the driver
>> supports. It allows for flexible driver side implementation and
>> easier for userspace to control.
>>
>
> Sorry - I dropped this thread accidentally.
>
> I'm not really sure I understand the situation fully, but right now to
> me this seems very strange.
>
> The physical antennas probably don't really change between "clamshell"
> and "tablet" mode, do the physical radiation properties change enough
> to actually require different *calibration*? To me, that sounds very
> strange.
>
> Assuming they don't really change fundamentally, then I understand the
> need to set different power levels, per band/channel/whatever
> granularity. But that can be achieved in very different ways, and in
> fact if you look at Chrome then for our iwl7000 driver there we do have
> a command to do something similar (currently a vendor command, but that
> can be changed) without ever changing the *calibration*.
>
> So to me, the whole premise of the patch is confusing and/or wrong.
>
> johannes



-- 
Wei-Ning Huang, 黃偉寧 | Software Engineer, Google Inc., Taiwan |
wnhuang@google.com | Cell: +886 910-380678
