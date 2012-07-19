Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:49204 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2GSCOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 22:14:17 -0400
Date: Thu, 19 Jul 2012 05:46:58 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Subject: Re: Issue related throughput on dot11s network
In-Reply-To: <CAEFj985JkiwFoEQ_KMY6pveGffZFSKktZV+qsKXw2NGbWcyWwA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1207190543530.4864@icf.org.ru> (sfid-20120719_041423_595084_3F002806)
References: <CAAOrG1r670TX9XrhjLX_4dHvhYHZ2hGvdoRa-trhhA6-BjZF5g@mail.gmail.com> <alpine.DEB.2.02.1207181706460.30765@icf.org.ru> <CAG6hwVPY6YRtcXovTshQ5WRsyem8gURF925kseXs6mOzOAyZ_Q@mail.gmail.com> <alpine.DEB.2.02.1207190426310.31728@icf.org.ru>
 <CAG6hwVMoy2NA=9fyKAh0spXGSmmX2uxRKghBPNewjtqwXXzujw@mail.gmail.com> <alpine.DEB.2.02.1207190456010.1329@icf.org.ru> <CAEFj985-ydPmSnG-=cbWpw_fTkBzPmtn9iVvDk9NpmOQMVe=Mw@mail.gmail.com> <alpine.DEB.2.02.1207190505190.1916@icf.org.ru>
 <CAEFj986gsrhmO3d8q=LPPPBW9aOrAHPq5TfwBDigUODbFx2a1Q@mail.gmail.com> <alpine.DEB.2.02.1207190512220.2315@icf.org.ru> <CAEFj987TJ3BaytndXwqbEEDct7Sh08EB0SbQ70wEb=ygkOjgPg@mail.gmail.com> <alpine.DEB.2.02.1207190532140.3840@icf.org.ru>
 <CAEFj985JkiwFoEQ_KMY6pveGffZFSKktZV+qsKXw2NGbWcyWwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-725064951-1342662418=:4864"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-725064951-1342662418=:4864
Content-Type: TEXT/PLAIN; charset=koi8-r
Content-Transfer-Encoding: 8BIT

BBBBBBOn 2012-07-19 09:42 +0800, Yeoh Chun-Yeow wrote devel@lists.open80211s.org:

ok, seems it's minstrel_ht related, i rebuild it with ath9k_rate_control, and it 
starting showing statistics.

YC>As Thomas suggested, perhaps it will be good to ask ath9k-devel group.
YC>
YC>"station dump" may not be a good indication. rc_stats is more accurate
YC>since it tells us the success transmission rate in our environment.
YC>
YC>Regards,
YC>Chun-Yeow
YC>
YC>On Thu, Jul 19, 2012 at 9:36 AM, Georgiewskiy Yuriy
YC><bottleman@icf.org.ru> wrote:
YC>> On 2012-07-19 09:31 +0800, Yeoh Chun-Yeow wrote devel@lists.open80211s.org:
YC>>
YC>> this stats is on compat-wireless-3.5-rc5-1-snpc, i also have openwrt trunk,
YC>> and yes, there is no stats too. iw dev mp0 station dump show rates around
YC>> 65 MBit/s MCS 6/7 on both sides.
YC>>
YC>> YC>It is strange that there is no statistic info at all. Are you using
YC>> YC>OpenWRT? I have the same problem using the latest trunk version. We
YC>> YC>need to know the transmission rate used to identify the success or
YC>> YC>failure of the specific assigned transmission rate. It may due to
YC>> YC>interference if only low transmission rate is used.
YC>> YC>
YC>> YC>Regards,
YC>> YC>Chun-Yeow
YC>> YC>
YC>> YC>On Thu, Jul 19, 2012 at 9:18 AM, Georgiewskiy Yuriy
YC>> YC><bottleman@icf.org.ru> wrote:
YC>> YC>> On 2012-07-19 09:10 +0800, Yeoh Chun-Yeow wrote devel@lists.open80211s.org:
YC>> YC>>
YC>> YC>> rate control is minstrel_ht on both side,
YC>> YC>>
YC>> YC>> rc_stats from one node is somehow all null:
YC>> YC>>
YC>> YC>> type      rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
YC>> YC>> HT20/LGI TtPMCS0        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS1        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS2        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS3        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS4        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS5        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS6        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS7        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS8        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS9        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS10       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS11       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS12       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS13       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS14       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS15       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS0        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS1        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS2        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS3        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS4        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS5        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS6        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS7        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS8        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS9        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS10       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS11       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS12       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS13       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS14       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS15       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS0        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS1        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS2        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS3        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS4        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS5        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS6        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS7        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS8        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS9        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS10       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS11       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS12       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS13       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS14       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS15       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>>
YC>> YC>> Total packet count::    ideal 0      lookaround 0
YC>> YC>> Average A-MPDU length: 1.0
YC>> YC>>
YC>> YC>> from another:
YC>> YC>>
YC>> YC>> type      rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
YC>> YC>> HT20/LGI  t MCS0        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS1        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS2        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS3        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS4        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS5        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS6        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI T PMCS7       39.0      100.0      100.0          1(  1)          1           1
YC>> YC>> HT20/LGI    MCS8        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS9        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS10       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS11       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS12       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS13       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS14       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT20/LGI    MCS15       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS0        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS1        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS2        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS3        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS4        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS5        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS6        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS7        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS8        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS9        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS10       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS11       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS12       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS13       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS14       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/LGI    MCS15       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS0        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS1        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS2        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS3        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS4        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS5        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS6        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS7        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS8        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS9        0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS10       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS11       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS12       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS13       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS14       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>> HT40/SGI    MCS15       0.0        0.0        0.0          0(  0)          0           0
YC>> YC>>
YC>> YC>> Total packet count::    ideal 0      lookaround 1
YC>> YC>> Average A-MPDU length: 1.0
YC>> YC>>
YC>> YC>>
YC>> YC>> YC>How about the rate control algorithm statistic for that particular
YC>> YC>> YC>station that you communicate with "rc_stats"?
YC>> YC>> YC>
YC>> YC>> YC>Regards,
YC>> YC>> YC>Chun-Yeow
YC>> YC>> YC>
YC>> YC>> YC>On Thu, Jul 19, 2012 at 9:06 AM, Georgiewskiy Yuriy
YC>> YC>> YC><bottleman@icf.org.ru> wrote:
YC>> YC>> YC>> On 2012-07-19 09:04 +0800, Yeoh Chun-Yeow wrote devel@lists.open80211s.org:
YC>> YC>> YC>>
YC>> YC>> YC>> iw phy phy0 interface add mp0 type mp
YC>> YC>> YC>> ifconfig mp0 hw ether 00:21:a4:35:36:24
YC>> YC>> YC>> iw dev mp0 set meshid Mesh
YC>> YC>> YC>> iw dev mp0 set channel 7 HT40+
YC>> YC>> YC>>
YC>> YC>> YC>> all this before bring interface up.
YC>> YC>> YC>>
YC>> YC>> YC>> YC>Hi, Georgiewskiy
YC>> YC>> YC>> YC>
YC>> YC>> YC>> YC>It will be good if you provide the "iw" command that you use for
YC>> YC>> YC>> YC>setting out the mesh nodes.
YC>> YC>> YC>> YC>
YC>> YC>> YC>> YC>Regards,
YC>> YC>> YC>> YC>Chun-Yeow
YC>> YC>> YC>> YC>_______________________________________________
YC>> YC>> YC>> YC>Devel mailing list
YC>> YC>> YC>> YC>Devel@lists.open80211s.org
YC>> YC>> YC>> YC>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>> YC>> YC>> YC>
YC>> YC>> YC>>
YC>> YC>> YC>> C уважением                       With Best Regards
YC>> YC>> YC>> Георгиевский Юрий.                Georgiewskiy Yuriy
YC>> YC>> YC>> +7 4872 711666                    +7 4872 711666
YC>> YC>> YC>> факс +7 4872 711143               fax +7 4872 711143
YC>> YC>> YC>> Компания ООО "Ай Ти Сервис"       IT Service Ltd
YC>> YC>> YC>> http://nkoort.ru                  http://nkoort.ru
YC>> YC>> YC>> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YC>> YC>> YC>> YG129-RIPE                        YG129-RIPE
YC>> YC>> YC>> _______________________________________________
YC>> YC>> YC>> Devel mailing list
YC>> YC>> YC>> Devel@lists.open80211s.org
YC>> YC>> YC>> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>> YC>> YC>>
YC>> YC>> YC>_______________________________________________
YC>> YC>> YC>Devel mailing list
YC>> YC>> YC>Devel@lists.open80211s.org
YC>> YC>> YC>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>> YC>> YC>
YC>> YC>>
YC>> YC>> C уважением                       With Best Regards
YC>> YC>> Георгиевский Юрий.                Georgiewskiy Yuriy
YC>> YC>> +7 4872 711666                    +7 4872 711666
YC>> YC>> факс +7 4872 711143               fax +7 4872 711143
YC>> YC>> Компания ООО "Ай Ти Сервис"       IT Service Ltd
YC>> YC>> http://nkoort.ru                  http://nkoort.ru
YC>> YC>> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YC>> YC>> YG129-RIPE                        YG129-RIPE
YC>> YC>> _______________________________________________
YC>> YC>> Devel mailing list
YC>> YC>> Devel@lists.open80211s.org
YC>> YC>> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>> YC>>
YC>> YC>_______________________________________________
YC>> YC>Devel mailing list
YC>> YC>Devel@lists.open80211s.org
YC>> YC>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>> YC>
YC>>
YC>> C уважением                       With Best Regards
YC>> Георгиевский Юрий.                Georgiewskiy Yuriy
YC>> +7 4872 711666                    +7 4872 711666
YC>> факс +7 4872 711143               fax +7 4872 711143
YC>> Компания ООО "Ай Ти Сервис"       IT Service Ltd
YC>> http://nkoort.ru                  http://nkoort.ru
YC>> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YC>> YG129-RIPE                        YG129-RIPE
YC>> _______________________________________________
YC>> Devel mailing list
YC>> Devel@lists.open80211s.org
YC>> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>>
YC>_______________________________________________
YC>Devel mailing list
YC>Devel@lists.open80211s.org
YC>http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
YC>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-725064951-1342662418=:4864--
