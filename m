Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49896 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaHRJOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 05:14:09 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so4656701wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2014 02:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHqTa-10bc+AtFbifObfqHXwzfcbrA5w9Z6LL53kUdDWeq=7ig@mail.gmail.com>
References: <CAHqTa-10bc+AtFbifObfqHXwzfcbrA5w9Z6LL53kUdDWeq=7ig@mail.gmail.com>
Date: Mon, 18 Aug 2014 11:14:07 +0200
Message-ID: <CA+BoTQnY1wV2DFrs4P6F+oz2vPH+tbziSGc-Gq=QOQfsrbf6wQ@mail.gmail.com> (sfid-20140818_111414_088200_B13C350F)
Subject: Re: Best choice of primary channels when using 40- or 80 MHz wide channels
From: Michal Kazior <michal.kazior@tieto.com>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 August 2014 01:42, Avery Pennarun <apenwarr@gmail.com> wrote:
> Hi all,
>
> I'm pretty confused about how to select the "primary" channel when
> using wide channels with 802.11ac (and also 802.11n, really).  My
> hostapd contains a section like this:
>
> hw_mode=a
> channel=149
> country_code=US
> ieee80211d=1
> ieee80211h=1
> ieee80211n=1
> ieee80211ac=1
> ht_capab=[HT20][HT40+][RX-STBC1]

There is no such thing as [HT20] in ht_capab in hostapd. You can just
remove it. It has no effect.


> vht_capab=[MAX-A-MPDU-LEN-EXP4]
> vht_oper_chwidth=1
> vht_oper_centr_freq_seg0_idx=155
>
> If I understand correctly, this will have the following results:
> - at 20 MHz, it will use channel 149
> - at 40 MHz, it will use channels 149+153 (HT40+)
> - at 80 MHz, it will use channels 149+153+157+161 (centr_freq_seg0_idx)

Basically, yes.


>
> This is fine when I'm the only AP around.  But let's imagine I'm in a
> crowded apartment building with lots of APs, and various clients
> support only 20 MHz channel width (increasingly rare), or 20/40, or
> 20/40/80.  In such a situation, we'd like to spread around the APs so
> that clients that can only do 20 or 40 don't always fall back to
> channel 149 or 149+153; otherwise we're just wasting tons of empty
> space on channels 157 and 161.
>
> The obvious way to do this would be to try a configuration like this (HT40-):
>
> channel=153
> ht_capab=[HT20][HT40-][RX-STBC1]
> vht_capab=[MAX-A-MPDU-LEN-EXP4]
> vht_oper_chwidth=1
> vht_oper_centr_freq_seg0_idx=155
>
> or perhaps this (40 Mhz uses upper half instead of lower half):
>
> channel=157
> ht_capab=[HT20][HT40+][RX-STBC1]
> vht_capab=[MAX-A-MPDU-LEN-EXP4]
> vht_oper_chwidth=1
> vht_oper_centr_freq_seg0_idx=155
>
> But when I try to do this, hostapd seems to abort and claim it can't
> register to use the channels.  Am I doing something wrong?  Is it
> hostapd version related?

All following configs work for me:

http://pastebin.com/w1LKTDGn
http://pastebin.com/McquAcCf
http://pastebin.com/1RNWHAAS
http://pastebin.com/kDd2RybJ

My hostapd is at 6d00ab04302df257cb3092b2b31b4eac42e77569.


>
> Also, hostapd contains code to swap the primary/secondary 20 MHz
> channels in the 40 MHz channel, based on what other APs are around.
> If I read correctly, it seems to want to use the same primary channel
> as everyone else.  Wouldn't it be better to equailze things to try to
> get about half the APs using each sub channel?

That would break 20/40 coex, wouldn't it?


Michał
