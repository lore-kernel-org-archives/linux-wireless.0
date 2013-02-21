Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:49183 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3BUBXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 20:23:43 -0500
Date: Thu, 21 Feb 2013 05:23:35 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
cc: devel@lists.open80211s.org, Adrian Chadd <adrian@freebsd.org>,
	ath9k-devel@lists.ath9k.org, Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAEFj9876NOQLNSjHjDGn34PSHi2nE6TJxc0zeMrEsG76c3d_aA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302210513170.21536@icf.org.ru> (sfid-20130221_022347_998498_E52CD169)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium> <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com> <20771.50338.434076.484711@gargle.gargle.HOWL> <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com> <20771.51233.248133.141840@gargle.gargle.HOWL>
 <alpine.DEB.2.02.1302192258510.19584@icf.org.ru> <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com> <alpine.DEB.2.02.1302200027120.19533@icf.org.ru> <CAEFj9871wuavGjjs=KRPK0Wq3gxeOxLP_Az6OU7LAJFw+W=6-g@mail.gmail.com>
 <alpine.DEB.2.02.1302202327450.2057@icf.org.ru> <alpine.DEB.2.02.1302210432480.22701@icf.org.ru> <CAEFj9876NOQLNSjHjDGn34PSHi2nE6TJxc0zeMrEsG76c3d_aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-362496608-1361409815=:21536"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-362496608-1361409815=:21536
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-21 09:08 +0800, Yeoh Chun-Yeow wrote Georgiewskiy Yuriy:

YC>All the mesh nodes will generate its own beacon same as IBSS. Adrian
YC>has mentioned that mode that supports multiple sources of beacons
YC>should be disabled the ANI. Perhaps, someone can comment on this why.

yes, but according to this there seems unnided check in ath9k_process_rssi for 
modes:

        if (!rx_stats->is_mybeacon ||
            ((ah->opmode != NL80211_IFTYPE_STATION) &&
             (ah->opmode != NL80211_IFTYPE_ADHOC)))
                 return;
                 
currently is_mybeacon true only in station mode, it set by this code:

                if (ieee80211_is_beacon(hdr->frame_control)) {
                        RX_STAT_INC(rx_beacons);
                        if (!is_zero_ether_addr(common->curbssid) &&
                            ether_addr_equal(hdr->addr3, common->curbssid))
                                rs.is_mybeacon = true;
                        else
                                rs.is_mybeacon = false;
                        }
                else
                        rs.is_mybeacon = false;

as i understand correctly common->curbssid exists only in client mode.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-362496608-1361409815=:21536--
