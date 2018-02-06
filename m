Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:40508 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbeBFLW4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 06:22:56 -0500
Received: by mail-qk0-f170.google.com with SMTP id d18so1774723qke.7
        for <linux-wireless@vger.kernel.org>; Tue, 06 Feb 2018 03:22:56 -0800 (PST)
Subject: Re: [PATCH 5/6] qtnfmac: implement asynchronous firmware loading
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
 <20180205150516.16030-6-sergey.matyukevich.os@quantenna.com>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A79900D.5080605@broadcom.com> (sfid-20180206_122300_558959_385038C5)
Date: Tue, 6 Feb 2018 12:22:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180205150516.16030-6-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/5/2018 4:05 PM, Sergey Matyukevich wrote:
> From: Sergei Maksimenko <smaksimenko@quantenna.com>
>
> In pci probe() function start firmware loading, protocol handshake
> and driver core initialization, and not wait for completion.

The moving of the debugfs stuff makes this a drag to review, but I get 
the gist. The thing is that the firmware api already provides an 
asynchronous api, ie. request_firmware_nowait(), so why not use that.

Regards,
Arend
