Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:7009 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYI1Qj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:39:57 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1654244fkq.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 09:39:55 -0700 (PDT)
Message-ID: <1ba2fa240809280939x31829a25wa46948d1f351c7a0@mail.gmail.com> (sfid-20080928_184002_791612_9095C58D)
Date: Sun, 28 Sep 2008 19:39:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS mode
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222619168.7064.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
	 <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com>
	 <1222619168.7064.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 28, 2008 at 7:26 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-28 at 19:24 +0300, Tomas Winkler wrote:
>
>> >> This patch makes mac80211 able to send action frames when toggling
>> >> (SM PS) Spacial Multiplexing Power Save mode.
>
>> > Why is the driver managing the PS mode to start with?
>>
>> What PS mode, SM PS mode or traditional PS mode? Please be more
>> verbose so I don't have to guess what you mean.
>
> This was mostly concerned about SM PS mode so that's what I'm asking.

Hmm, I hoped that two examples I gave explains that. Now I see I
missed one sentence
in the first example, the movement between PS mode and CAM mode can be
actually controlled
by mac80211 it just need to convey to AP MS PS mode supported by HW.
Bottom line this is dependent on
HW capabilities.

Second example, only low level driver is running calibrations and
knows if it has all rx chains available. The possibility is
that not all platforms connect all antennas or physical environment
between AP and STA cause some of the antennas not affective
we may propagate rx chain status to mac80211 but if this is not
opening too much guts. Sometimes it's just hard to keep a clean cut.

I have two more patches for these to example of course...

>I don't actually know what that is anyway though, hence the question.

Actually this is one of more understandable part of the spec.

 We
> keep adding API in mac80211 and nobody really knows when to call it.
> Maybe you should (maybe team up with Atheros for it) write a "HT
> hardware with mac80211" chapter in the documentation?

Yes we should.
Tomas
