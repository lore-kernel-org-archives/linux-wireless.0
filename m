Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37245 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932417AbcKVPUc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 10:20:32 -0500
Received: by mail-wm0-f49.google.com with SMTP id t79so30592402wmt.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 07:20:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xadDx=+Yc+vPKtyOG6-w-BRa09OyrE_N09p9juipuur0w@mail.gmail.com>
References: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
 <20161120010740.GB3581@localhost> <CA+BoTQm9DBc_tkQnXwLVuV6dbsEixn73t_TRk1akktTiwRm_0w@mail.gmail.com>
 <CAHdg3xZMJw47Zyh9ubawysGqo6N2qcNUXX1o19GyFYOHv8GivA@mail.gmail.com>
 <CA+BoTQ=xCmYtqrMZpoqtNUTN8e_WE=AFpqU3LQdopiSik5eODA@mail.gmail.com>
 <CAHdg3xYFWiC1YegR8U9WJ52zjYK242eYWHvx8rsuY6RZvD+9og@mail.gmail.com> <CAHdg3xadDx=+Yc+vPKtyOG6-w-BRa09OyrE_N09p9juipuur0w@mail.gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 22 Nov 2016 16:20:30 +0100
Message-ID: <CA+BoTQnKkkHohMmaYStKnMGjJCvDmci2w2YH5UrObjG+cYBkZA@mail.gmail.com> (sfid-20161122_162035_832819_6E03BBDC)
Subject: Re: ath10k stuck in mesh mode
To: Matteo Grandi <iu5bdp@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 November 2016 at 10:43, Matteo Grandi <iu5bdp@gmail.com> wrote:
> Dear Bob, Michal, all
>
> I've finally managed to have a 80MHz channel bandwidth, thanks to your hint!
> The problem was related to the CRDA that even if it looks correctly
> installed, it actually doesn't work as supposed.
> I downloaded and recompiled the CRDA-3.18
> (http://drvbp1.linux-foundation.org/~mcgrof/rel-html/crda/) and set-up
> the regulatory domain.
> Notice that without setting up the reg. domain all the available
> channels have the "passive scanning" label because the CRDA prevent
> beaconing so mesh mode is not possible (maybe it's otherwise possible
> to operate in STA mode that doesn't require to send frames(?)).

STA can be allowed to transmit via beacon hints as far as I understand.


> Now I can have a mesh communication using 80MHz channel bandwidth, but
> MIMO still doesn't work.
> In fact the highest MCS reached was MCS9 that is the highest MCS with
> Single Spatial Stream, and I can't managed to have MIMO.

11n used mcs to imply nss. 11ac treats mcs and nss separately.
Therefore saying "MCS9 is 1SS" is incorrect. How are you checking
this? What device are you using for verifying?


> I played with the antennas position and distance, with the
> polarization and the presence or not of LOS, but by sniffing the
> transmissions I sow only MCS9 even if in the radiotap header field
> there are Antenna 0 and Antenna 1.
> However the radio information field report "Spatial streams: 1".
>
> Does anyone experienced something similar with the use of MIMO in mesh
> mode with the ath10k fw?
> I will thank any light you can shed to this!
> Thank you very much

You might want to debug peer_assoc commands sent to firmware. They may
be, for some reason, be requesting nss=1. Maybe sta_rc_update() isn't
properly updating peer in firmware. Driver debugs/dumps
(debug_mask=0xffffffffff) would be useful.


Michal
