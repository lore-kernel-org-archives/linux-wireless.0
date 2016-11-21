Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37759 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753972AbcKUKxi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 05:53:38 -0500
Received: by mail-wm0-f50.google.com with SMTP id t79so136963652wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 02:53:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xZMJw47Zyh9ubawysGqo6N2qcNUXX1o19GyFYOHv8GivA@mail.gmail.com>
References: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
 <20161120010740.GB3581@localhost> <CA+BoTQm9DBc_tkQnXwLVuV6dbsEixn73t_TRk1akktTiwRm_0w@mail.gmail.com>
 <CAHdg3xZMJw47Zyh9ubawysGqo6N2qcNUXX1o19GyFYOHv8GivA@mail.gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 21 Nov 2016 11:53:36 +0100
Message-ID: <CA+BoTQ=xCmYtqrMZpoqtNUTN8e_WE=AFpqU3LQdopiSik5eODA@mail.gmail.com> (sfid-20161121_115342_389796_29EEA965)
Subject: Re: ath10k stuck in mesh mode
To: Matteo Grandi <iu5bdp@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2016 at 10:46, Matteo Grandi <iu5bdp@gmail.com> wrote:
> Dear Bob, Michal, all,
>
> I've just tried your advices (actually I already tried it following
> the wireless.wiki.kernel web pages) and I had a look at the syslog
> while I was typing the commands
> At the beginning I have this
[...]
> Other (hopefully) useful info:
> root@MrProper:~# iw reg get
> global
> country US: DFS-UNSET
>     (2402 - 2472 @ 40), (3, 27), (N/A)
>     (5170 - 5250 @ 40), (3, 17), (N/A)
>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>     (5735 - 5835 @ 40), (3, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> phy#2
> country US: DFS-UNSET
>     (2402 - 2472 @ 40), (3, 27), (N/A)
>     (5170 - 5250 @ 40), (3, 17), (N/A)
>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>     (5735 - 5835 @ 40), (3, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> phy#0
> country US: DFS-UNSET
>     (2402 - 2472 @ 40), (3, 27), (N/A)
>     (5170 - 5250 @ 40), (3, 17), (N/A)
>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>     (5735 - 5835 @ 40), (3, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>
> phy#1
> country US: DFS-UNSET
>     (2402 - 2472 @ 40), (3, 27), (N/A)
>     (5170 - 5250 @ 40), (3, 17), (N/A)
>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>     (5735 - 5835 @ 40), (3, 30), (N/A)
>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>[...]
>
> Checking on Internet I didn't find a working solution, and the data
> rate stucks to 120Mbps MCS7.
> For me it still a mistery, I hope in your help.

Note the "@ 40" for all frequency ranges (except 60GHz band). Your
regulatory database seems to be limiting you to 40 MHz (it's probably
very old/ out of date). You'll need to update it to be able to use 80
MHz.


Michal
