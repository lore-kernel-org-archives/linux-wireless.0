Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57987 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1GSQG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 12:06:58 -0400
Received: by ywe9 with SMTP id 9so1843589ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 09:06:58 -0700 (PDT)
Message-ID: <4E25AB9F.8010607@lwfinger.net> (sfid-20110719_180701_864002_3C918570)
Date: Tue, 19 Jul 2011 11:06:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: ali@internetdog.org, wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
References: <4E2051F3.20103@redhat.com> <4E205984.5040803@lwfinger.net> <4E23E56C.9000202@redhat.com> <20110718082709.GA8390@internetdog.org> <4E23F2E0.3050200@redhat.com> <4E2448D2.50502@lwfinger.net> <4E244AC6.2030306@redhat.com> <4E2454EC.1050900@lwfinger.net> <4E25858D.9010407@redhat.com>
In-Reply-To: <4E25858D.9010407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2011 08:24 AM, Stefan Assmann wrote:
>
> So far I can say that with scan_ssid=1 after rebooting the AP the
> connection is properly re-established. Looks promising.

Your results make sense. The driver is fairly passive in all this. It gets TX 
requests from the MAC layer, and passes received data back up to that layer. It 
seems likely that the MAC layer built into r8712u is not keeping track of 
missing responses, or it is not probing the AP. In either case, it would not be 
productive to devote any effort to fixing that part when either using 
NetworkManager or setting scan_ssid for wpa_supplicant establishes periodic 
scans. When these fail to get response from the AP, the softmac code will 
respond, as you see.

The ultimate fix will be to convert to the driver to use mac80211, which is a 
much better MAC layer. That is on my TODO list, but it has low priority.

Larry
