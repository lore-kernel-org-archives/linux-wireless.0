Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20.bullet.mail.bf1.yahoo.com ([98.139.212.179]:32420 "HELO
	nm20.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753411Ab1FVOqn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 10:46:43 -0400
References: <loom.20110621T215346-191@post.gmane.org>  <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>  <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>  (sfid-20110622_154146_913504_76736765) <1308750416.29571.10.camel@jlt3.sipsolutions.net>
Message-ID: <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com> (sfid-20110622_164646_873767_DE57193A)
Date: Wed, 22 Jun 2011 07:41:09 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: Performance regression between Madwifi/net80211 and ath5k/mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1308750416.29571.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,
I'm glad that you take an interest. Here are my observations:

To put some meat to my claims about the performance difference, I'm
providing the summary lines from the TCP iperf server side:

         [ ID]  Interval      Transfer     Bandwidth
madwifi: [  4]  0.0-10.5 sec  30.9 MBytes  24.7 Mbits/sec
ath5k  : [  4]  0.0-10.8 sec  26.0 MBytes  20.2 Mbits/sec

Note the significant difference in the bandwidth column.

To answer your actual question: No, there doesn't seem to be a
difference in CPU usage as shown by top. If anything, madwifi 
seems to use a little bit more:

madwifi: 85,5% idle, 10% si
ath5k  : 89% idle,   10% si

The CPU is:

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 13
model name    : Intel(R) Celeron(R) M processor         1.00GHz
stepping    : 8
cpu MHz        : 999.954
cache size    : 512 KB
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 2
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov clflush 
dts acpi mmx fxsr sse sse2 ss tm pbe nx up bts
bogomips    : 1999.90
clflush size    : 64
cache_alignment    : 64
address sizes    : 32 bits physical, 32 bits virtual
power management:


Anything else I can do?

-- 
Thanks in advance and kind regards 
Joerg 




----- Original Mail ----
> Von: Johannes Berg <johannes@sipsolutions.net>
> An: Joerg Pommnitz <pommnitz@yahoo.com>
> CC: Adrian Chadd <adrian@freebsd.org>; linux-wireless@vger.kernel.org; 
>ath5k-devel@lists.ath5k.org
> Gesendet: Mittwoch, den 22. Juni 2011, 15:46:56 Uhr
> Betreff: Re: Performance regression between Madwifi/net80211 and 
ath5k/mac80211
>
> Do you see different CPU usage? Does it max  out? If so can you profile
> it?
> 
> johannes
> 
> 
