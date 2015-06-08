Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f52.google.com ([209.85.216.52]:46629 "EHLO
	mail-vn0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbbFHR2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 13:28:13 -0400
Received: by vnbf7 with SMTP id f7so18635826vnb.13
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 10:28:12 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986CCryd1fK6NpoQYOmCiu+KRjq8RsSgvWqQOvLBPvFoeg@mail.gmail.com>
 <CAEFj987VjaQpwx2VMxYeH7TWcKVvjN6hSRsqTSbSXa1ZammezQ@mail.gmail.com>
In-Reply-To: <CAEFj987VjaQpwx2VMxYeH7TWcKVvjN6hSRsqTSbSXa1ZammezQ@mail.gmail.com>
MIME-Version: 1.0
Date: Mon, 8 Jun 2015 10:28:12 -0700
Message-ID: <3ae0dc14a0cf7a0d8008a49dd6b2376f@mail.gmail.com> (sfid-20150608_192816_486529_A0BDCCEE)
Subject: RE: [PATCH] mac80211: Fix a case of incorrect metric used when
 forwarding a PREQ
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I took a look at the spec too and also didn't see mention of the MP_F_RF
flag. Section 13.10.9.3 for example talks about PREQ handling and in case E2
talks about sending replies back. It says to do that if target only is not
set which makes sense: MP_F_RF and MP_F_DO are exclusive options so it's
silly to use two different flags for them.

But for the purposes of this patch that is a moot issue: the semantics of
the function don't change and the original code was both confusing and using
the wrong value for metric for the not target only, intermediate station
case.

  -- Jesse

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Yeoh Chun-Yeow
Sent: Monday, June 08, 2015 1:55 AM
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix a case of incorrect metric used when
forwarding a PREQ

As mentioned in Section 13.10.9.3 Case E2, the PREQ forwarding should use
metric "as received + own metric toward transmitter of received PREQ". So
you are right.

Just MP_F_RF bit is no longer use. After replying with PREP, forwarding the
PREQ by setting the IEEE80211_PREQ_TO_FLAG in the per target flags.

---
Chun-Yeow

On Mon, Jun 8, 2015 at 4:07 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
wrote:
> Hi, Alexis Green
>
> I just take a look back on the code before implementing the Proactive
> PREQ for PREP. For the case of reply and forward (target_flags &
> MP_F_RF), the previous metric used is the one which resolved from
> mpath->metric.
>
> Refer here:
> https://github.com/o11s/open80211s/blob/o11s-0.4.2/net/mac80211/mesh_h
> wmp.c
>
> But to say that, I cannpt confirm whether this is correct. The
> standard 802.11-2012 has no longer specified bit-1 MP_F_RF (Refer
> section 8.4.2.115 per target flag). So maybe it is not relevant
> anymore. We may need to remove as well.
>
> ----
> Chun-Yeow
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
