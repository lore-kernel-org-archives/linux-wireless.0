Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35026 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750900AbcLCG7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 01:59:06 -0500
Received: by mail-pg0-f50.google.com with SMTP id p66so115783946pga.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2016 22:59:06 -0800 (PST)
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF
 synchronization
To: Bob Copeland <me@bobcopeland.com>,
        Thomas Pedersen <thomas@eero.com>
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
 <20161202211351.GA5571@localhost>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com> (sfid-20161203_075914_226371_0B241E16)
Date: Sat, 3 Dec 2016 15:59:03 +0900
MIME-Version: 1.0
In-Reply-To: <20161202211351.GA5571@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016/12/03 06:13, Bob Copeland wrote:
> On Fri, Dec 02, 2016 at 12:07:18PM -0800, Thomas Pedersen wrote:

# Rejected by linux wireless ML. This is resubmission.

thomas and Bob, Thanks for comments.

 > 802.11-2012 13.13.2.2.3:
 > The mesh STA checks if the transmitter of the Beacon frame or Probe
 > Response frame is in the
 > process of the TBTT adjustment (see 13.13.4.4.3).

There are two functionalities.

1) 13.13.2.2 Neighbor offset synchronization method
2) 13.13.4.4 TBTT adjustment

The ifmsh->adjusting_tbtt flag implements "TBTT Adjusting field" in the
Mesh Configuration field.

The flag is updated by 2).
13.13.4.4.3 TBTT scanning and adjustment procedures:
The mesh STA shall set the TBTT Adjusting field in the Mesh
Configuration element to 1 in order to announce that the TBTT
adjustment procedure is ongoing.

And the flag is refered by 1) as you said.

The purpose of the flag is to prevent 1) while 2) is ongoing.

In other words, 1) has only read access authority to the flag. However,
previous code updated the flag in 1). In addition, there is no code for
2). So I just remove the invalid accessing codes.

Masashi Honma.
