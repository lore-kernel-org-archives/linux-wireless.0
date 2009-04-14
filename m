Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:64599 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbZDNS2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 14:28:17 -0400
Received: by fg-out-1718.google.com with SMTP id 16so517020fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 11:28:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239733412.24771.13.camel@johannes.local>
References: <69e28c910904141109n4aa5cf20k39d1e75e33907977@mail.gmail.com>
	<1239733412.24771.13.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 14 Apr 2009 20:27:59 +0200
Message-ID: <69e28c910904141127s1b809238x1359d9fc12d1215e@mail.gmail.com> (sfid-20090414_202840_377086_2554E08F)
Subject: Re: [PATCH] rtl8187: Disable TX retries if IEEE80211_TX_CTL_NO_ACK is
	set
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/14 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2009-04-14 at 20:09 +0200, G=E1bor Stefanik wrote:
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!info->flags & IEEE80211_TX_CTL_NO_ACK=
))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hdr->retry =3D cpu_to_le32=
((info->control.rates[0].count - 1) << 8);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hdr->retry =3D 0;
>
> Umm. You obviously didn't even _COMPILE_ that patch. Let alone test i=
t
> properly.
>
> johannes
>

Oops... yes, it ways a straight rewrite of my old patch for
2.6.28-rc6-wl, and I apparently got the rewrite wrong.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
