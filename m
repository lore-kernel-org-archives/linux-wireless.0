Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33270 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbcLER7r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 12:59:47 -0500
Received: by mail-oi0-f50.google.com with SMTP id w63so349910064oiw.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 09:59:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
 <20161202211351.GA5571@localhost> <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Mon, 5 Dec 2016 09:59:45 -0800
Message-ID: <CADjYELw=-LEqDra0pM+3FjtJDve+NiNYEMz5=F0i5Ge-5k3LaA@mail.gmail.com> (sfid-20161205_185950_753650_D2725CC5)
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF synchronization
To: Masashi Honma <masashi.honma@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 2, 2016 at 10:59 PM, Masashi Honma <masashi.honma@gmail.com> wrote:
> On 2016/12/03 06:13, Bob Copeland wrote:
>>
>> On Fri, Dec 02, 2016 at 12:07:18PM -0800, Thomas Pedersen wrote:
>
>
> # Rejected by linux wireless ML. This is resubmission.
>
> thomas and Bob, Thanks for comments.
>
>> 802.11-2012 13.13.2.2.3:
>> The mesh STA checks if the transmitter of the Beacon frame or Probe
>> Response frame is in the
>> process of the TBTT adjustment (see 13.13.4.4.3).
>
> There are two functionalities.
>
> 1) 13.13.2.2 Neighbor offset synchronization method
> 2) 13.13.4.4 TBTT adjustment
>
> The ifmsh->adjusting_tbtt flag implements "TBTT Adjusting field" in the
> Mesh Configuration field.
>
> The flag is updated by 2).
> 13.13.4.4.3 TBTT scanning and adjustment procedures:
> The mesh STA shall set the TBTT Adjusting field in the Mesh
> Configuration element to 1 in order to announce that the TBTT
> adjustment procedure is ongoing.
>
> And the flag is refered by 1) as you said.
>
>
> The purpose of the flag is to prevent 1) while 2) is ongoing.
>
> In other words, 1) has only read access authority to the flag. However,
> previous code updated the flag in 1). In addition, there is no code for
> 2). So I just remove the invalid accessing codes.

I don't think 1) has read only access to that flag. A TSF adjust will
by definition move the TBTT as well.

-- 
thomas
