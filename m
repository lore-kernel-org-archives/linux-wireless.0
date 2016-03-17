Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:41029 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967359AbcCQRYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 13:24:52 -0400
Subject: Re: [Codel] [RFCv2 0/3] mac80211: implement fq codel
To: Dave Taht <dave.taht@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
 <CA+BoTQ=65mHN5iLnZjTE+tyEG7nfmCx4NZNbGRF6+VpRaNmOYw@mail.gmail.com>
 <CAA93jw5cUaj_qM+CYHHoRaghLDLC+BUgF4AjT=Oec+SB-zb74g@mail.gmail.com>
 <CAA93jw6tDdiYuginPbUY1DFJLiDxofHMFN6j2BvQPabPmBtuRw@mail.gmail.com>
 <20160316185531.GA1771@localhost>
 <CAGyitvMDEUiNx7HD=XKjXNHnFvZ_gxD_BbQx3AP-57_+dBeD4A@mail.gmail.com>
 <CA+BoTQnFN6VANn=5EUvHc0Dbfh4Zv0HraOto2ySN3_HdOpD7Sg@mail.gmail.com>
 <CAA93jw7TuBLVi9k-+2=J27j-Qs+sS3UNaQNTMF9D2MQ13fQY9A@mail.gmail.com>
Cc: Network Development <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Jasmine Strong <jas@eero.com>,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	make-wifi-fast@lists.bufferbloat.net
From: Rick Jones <rick.jones2@hpe.com>
Message-ID: <56EAE85F.3010407@hpe.com> (sfid-20160317_182457_240634_E47A591A)
Date: Thu, 17 Mar 2016 10:24:47 -0700
MIME-Version: 1.0
In-Reply-To: <CAA93jw7TuBLVi9k-+2=J27j-Qs+sS3UNaQNTMF9D2MQ13fQY9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/17/2016 10:00 AM, Dave Taht wrote:
> netperf's udp_rr is not how much traffic conventionally behaves. It
> doesn't do tcp slow start or congestion control in particular...

Nor would one expect it to need to, unless one were using "burst mode" 
to have more than one transaction inflight at one time.

And unless one uses the test-specific -e option to provide a very crude 
retransmission mechanism based on a socket read timeout, neither does 
UDP_RR recover from lost datagrams.

happy benchmarking,

rick jones
http://www.netperf.org/
