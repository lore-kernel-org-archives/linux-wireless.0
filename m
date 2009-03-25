Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43798 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZCYHo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 03:44:56 -0400
Received: by ewy9 with SMTP id 9so2395882ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 00:44:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c1e027750903250041qfb28bb5g69bc219da57736c0@mail.gmail.com>
References: <c1e027750903250041qfb28bb5g69bc219da57736c0@mail.gmail.com>
Date: Wed, 25 Mar 2009 13:14:54 +0530
Message-ID: <c1e027750903250044o1da1cddewbf97bc708ad05d8d@mail.gmail.com> (sfid-20090325_084458_318607_7A70D101)
Subject: Scan in compat-wireless
From: Venkat Ch <venkatch@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

=A0Last week I have downloaded compat-wireless driver. I have installed
the same into my laptop which has AR242x based WiFi card. Though the
drivers are loaded correctly, the STA (my laptop) did not associate
with the nearby AP. The association used to happen well when I used
madwifi driver.

With my past experience with the code details of madwifi driver, I
have browsed through the code base of compat-wireless driver. I
observed that, with madwifi driver when the device is made up, the
scan process is kicked off. Where as the same is not happening in
compat-wireless. Does not the scan process need to be kicked off at
the end of ieee80211_open (net/mac80211/iface.c)?

Also for ath5k driver, both the hw_scan and sw_scan_start are not
defined. These two functions are used in ieee80211_start_scan to start
the scan process (net/mac80211/scan.c). I observed that the scan
process is not started because the above two functions are not
defined.

Is the scan functionlaity yet to be added? I have verified the TODO
list of linux-wireless page. I did not find scan in the agenda. Is
some one already implementing the functionality? Please let me know if
I need to provide further details.


Thanks & Regards
Venkat

--
Peace is its own reward
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
