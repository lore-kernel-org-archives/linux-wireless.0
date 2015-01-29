Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:64940 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbA2WHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 17:07:35 -0500
Received: by mail-lb0-f177.google.com with SMTP id p9so33158303lbv.8
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 14:07:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422566048629.36984@mail.polimi.it>
References: <1422566048629.36984@mail.polimi.it>
Date: Thu, 29 Jan 2015 23:07:33 +0100
Message-ID: <CACna6rz+tdayzFcNW8+AVVesj1KNLYAYURasT20gQ=Ykxog-=Q@mail.gmail.com> (sfid-20150129_230738_306721_093A407D)
Subject: Re: "iw": two small questions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Stefano Cappa <stefano.cappa@mail.polimi.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 January 2015 at 22:14, Stefano Cappa <stefano.cappa@mail.polimi.it> wrote:
> 1) It's possibile that "iw phy phy0 info" said that i can use a particular combination of interfaces in "Valid interface combinations" but on my device i can't use this combination? If yes, the problem is with the driver of this device?

Could happen. @add_virtual_intf (see struct cfg80211_ops) can fail.


> 2) How iw obtains the information to print "Valid interface combinations"? iw asks this information to the driver/hardware/or something else ?

See "struct wiphy" and its
const struct ieee80211_iface_combination *iface_combinations;

-- 
Rafał
