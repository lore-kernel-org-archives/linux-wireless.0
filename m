Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:35600 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab1IZHXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 03:23:31 -0400
Received: by mail-yx0-f173.google.com with SMTP id 11so5308499yxl.18
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 00:23:30 -0700 (PDT)
Message-ID: <4E80286C.8090801@ti.com> (sfid-20110926_092336_506104_3FE412F2)
Date: Mon, 26 Sep 2011 10:23:24 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: "Levi, Shahar" <shahar_levi@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>  <1316698619.2157.628.camel@cumari> <1316775583.2157.728.camel@cumari>  <CAHiDVwkeMTYdVubk=YPp6XTfNtmr2+mTwuX-ED0TcmzmrvEfUw@mail.gmail.com> <1317018322.2171.17.camel@cumari>
In-Reply-To: <1317018322.2171.17.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/09/2011 09:25, Luciano Coelho wrote:
>>> I checked this a bit further and I don't see the point in sending all
>>> packets here.  In fact, if block_tx is set, we can't even send any more
>>> frames until the switch happens (or fails).  So we should at least check
>>> this here.
>> The block_tx is taken into account in the mac layer.
>
> This is a bit strange, though.  I checked the code and nobody seems to
> be using the block_tx element of ieee80211_channel_switch, so I wonder
> why it's there at all.
>

As far as I know the block_tx is for the DFS channel switch 
implementation, when block_tx=1, the firmware will not start tx on new 
channel.

Victor.
