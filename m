Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:43047 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYG3X2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 19:28:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so363303wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 16:28:22 -0700 (PDT)
Message-ID: <3ace41890807301628i266a0b84p1620e19a4890c108@mail.gmail.com> (sfid-20080731_012827_645641_E7CEF151)
Date: Thu, 31 Jul 2008 00:28:22 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] rtl8187: Fix lockups due to concurrent access to config routine
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4890ebe1.V0mFuwprQdb+lXy5%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4890ebe1.V0mFuwprQdb+lXy5%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/30/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Some users of the RTL8187B have experienced difficulties since commit
>  8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
>  management wext hooks. This difficulty has not made much sense until
>  it was realized that it was possible for mac80211 to make a call to the
>  config routine while that routine was already being executed. This patch
>  protects the critical section with a mutex.
>
>  The problem was found by Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
>  who also suggested this type of fix.
>
>  Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>  Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

The mutex patch seems to also improve interaction with
NetworkManager/wpa_supplicant (possibly duo core issues as well?).
