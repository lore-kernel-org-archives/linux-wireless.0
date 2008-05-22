Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:15163 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761981AbYEVKT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 06:19:28 -0400
Received: by el-out-1112.google.com with SMTP id s27so1038751ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 03:19:27 -0700 (PDT)
Message-ID: <69e28c910805220319y52f13b55h5692be4c3d1788a4@mail.gmail.com> (sfid-20080522_121933_342359_3BF4DB0C)
Date: Thu, 22 May 2008 12:19:27 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH V2] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1211447857.3698.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <69e28c910805210819ye492edkc20b1ddccdf082ce@mail.gmail.com>
	 <1211447545.7814.97.camel@debian.sh.intel.com>
	 <1211447857.3698.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 11:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-05-22 at 17:12 +0800, Zhu Yi wrote:
>> On Wed, 2008-05-21 at 17:19 +0200, Stefanik G=E1bor wrote:
>> > also works in monitor-while-associated mode.
>>
>> How does it work? AFAICS, mac80211 wext.c blocks setting essid and b=
ssid
>> in monitor mode. Did you patch it?
>
> You just create two virtual interfaces. Which, incidentally, iwlwifi
> seems to be quite buggy about: it will accept all types, even those i=
t
> doesn't support (mesh, ap, wds?)
>
> johannes
>

Exactly. I should have wrote multi-VAP mode, since that's what it
really is, except for that it doesn't panic, unlike madwifi's
similarly named mode. Wext.c blocks setting ESSID and BSSID for
monitor interfaces - but there is nothing that prevents a monitor and
a station interface to coexist on the same wmaster - and even though
setting ESSID and BSSID on the monitor interface (call it "rtap0") is
blocked, they still work on the station interface (for example,
"wlan0"). (This multi-interface mode is exposed by the iw tool, as
well as aircrack-ng's airmon-ng script, which essentially acts as a
front-end for iw.)

G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
