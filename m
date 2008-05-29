Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:35172 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYE2H03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 03:26:29 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1970796fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 00:26:27 -0700 (PDT)
Message-ID: <c85cb4470805290026m2db5f51fp20a283b20d04e0d9@mail.gmail.com> (sfid-20080529_092632_945749_357CDE13)
Date: Thu, 29 May 2008 10:26:27 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Senthil Balasubramanian" <senthilkumar@atheros.com>
Subject: Re: [PATCH] mac80211: Fix for NULL pointer dereference in sta_info_get()
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080528143812.GA5244@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080528143812.GA5244@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The proper way to fix is to change the data type of TID to u8
> instead of u16. However changing all the occurences requires
> some prototype changes as well. We should fix this in upcoming
> patches.

excellent. currently it is u16 from historical reasons more then
anything else (once treated bit pos as tid num)
