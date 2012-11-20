Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52045 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2KTWpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 17:45:07 -0500
Message-ID: <50AC07F2.8000400@monom.org> (sfid-20121120_234512_177089_ABE5E097)
Date: Tue, 20 Nov 2012 23:45:06 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com> <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org> <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org> <20121120205418.GB26602@thinkpad-t410> <50AC05A5.3090706@monom.org>
In-Reply-To: <50AC05A5.3090706@monom.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Looks like you got it right. The period you traced doesn't seem to cover
>> any of the block ack session timeouts, but I do see this:
>>
>> [  225.269777] wlan0: release an RX reorder frame due to timeout on earlier frames
>> [  243.869220] wlan0: unexpected AddBA Req from 1c:c6:3c:1f:50:68 on tid 0
>> [  243.869233] wlan0: Rx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0 recipient reason: 32
>> [  243.869250] wlan0: Rx A-MPDU request on tid 0 result 0
>> [  252.254013] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 13
>> <snip repeated messages>
>> [  259.798966] wlan0: release an RX reorder frame due to timeout on earlier frames
>> <snip repeated messages>
>> [  265.193640] wlan0: unexpected AddBA Req from 1c:c6:3c:1f:50:68 on tid 0
>> [  265.193648] wlan0: Rx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0 recipient reason: 32
>> [  265.193663] wlan0: Rx A-MPDU request on tid 0 result 0
>>
>> Does something in this time frame correspond to your loss in
>> connectivity? The number of packets being sent and received varies some
>> throughout the trace but generally stays pretty low. It never completely
>> stops though.
>
> I am currently not able to reproduce a complete loss of connectivity.

I fear it is a heisenbug. After turning the tracing off I was able to 
reproduce it very easily.


