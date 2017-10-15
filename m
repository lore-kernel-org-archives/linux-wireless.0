Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:46865 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdJONlu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 09:41:50 -0400
Received: by mail-wm0-f53.google.com with SMTP id m72so28896088wmc.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Oct 2017 06:41:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171015095133.prxuuukv6osx52td@bars>
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
 <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com> <20171015095133.prxuuukv6osx52td@bars>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Oct 2017 00:41:29 +1100
Message-ID: <CAGRGNgX5pzhdXiBu2pK_2YYQVwyUzS4yz5Rs-J8JuP5MdCLrnQ@mail.gmail.com> (sfid-20171015_154202_580515_351DA9D3)
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
To: Steve deRosier <derosier@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sergey,

On Sun, Oct 15, 2017 at 8:51 PM, Sergey Matyukevich
<sergey.matyukevich.os@quantenna.com> wrote:
>> > Add new command to register for receiving multiple mgmt frames,
>> > capture and print them. Frames are selected by their type and
>> > pattern containing their the first several bytes of the frame
>> > that should match.
>> >
>>
>> Forgive me for asking, what does this provide that isn't already
>> available in tshark? And since we already have user-space tools
>> tailored for capturing and filtering any frames, including management
>> frames, why do we need to add this to iw?
>
> IIUC tshark and other specific capture tools need wireless netdevice to be
> in monitor mode. This particular iw command is based on NL80211_CMD_REGISTER_FRAME
> and related cfg80211 ops. In fact, this command can be used to subscribe
> to mgmt frames when wireless device is up and running in AP or STA mode.
> That can be convenient for monitor and debug purposes. There is a
> limitation though: currently cfg80211 core allows only one subscriber
> for each particular frame/pattern.

Stupid question: Can Wireshark / Tshark be taught how to do this?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
