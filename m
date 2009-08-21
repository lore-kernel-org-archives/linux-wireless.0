Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:14692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZHUBHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 21:07:37 -0400
Received: by rv-out-0506.google.com with SMTP id f6so109659rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 18:07:38 -0700 (PDT)
Message-ID: <4A8DF356.8000501@lwfinger.net>
Date: Thu, 20 Aug 2009 20:07:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B
References: <200908202116.17847.herton@mandriva.com.br>
In-Reply-To: <200908202116.17847.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> RTL8187B always needs MSR_LINK_ENEDCA flag to be set even when it is in
> no link mode, otherwise it'll not be able to associate when this flag is
> not set after the change "mac80211: fix managed mode BSSID handling"
> (commit 9cef8737).
> 
> By accident, setting BSSID of AP before association makes 8187B to
> successfuly associate even when ENEDCA flag isn't set, which was the
> case before the mac80211 change. But now the BSSID of AP we are trying
> to associate is only available after association is successful, and
> any attempt to associate without the needed flag doesn't work.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

I had just finished bisecting the problem reported in Bug #13960 when
this patch from Herton appeared in my mailbox, and it fixed the problem.

Larry
