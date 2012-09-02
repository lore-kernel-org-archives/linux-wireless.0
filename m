Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58063 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2IBXC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 19:02:29 -0400
Received: by ieje11 with SMTP id e11so3021026iej.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Sep 2012 16:02:29 -0700 (PDT)
Message-ID: <5043E582.6070205@lwfinger.net> (sfid-20120903_010233_586023_7DF08501)
Date: Sun, 02 Sep 2012 18:02:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: coekbe <coekbe@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] rtl8192cu: completing beaconing support
References: <CAK678xg-uD6rKdcZVksAdAwMtsvmcn6GmYsSa1gWS=CNTLpenw@mail.gmail.com>
In-Reply-To: <CAK678xg-uD6rKdcZVksAdAwMtsvmcn6GmYsSa1gWS=CNTLpenw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/02/2012 01:50 PM, coekbe wrote:
> Hi All,
>
> Beaconing support in rtl8192cu (AP and ad-hoc modes) was already
> mostly there, but code for actually sending out beacon frames was
> missing. The following patch works for me, meaning that I can use
> hostapd to set up a functioning AP.
>
> Beaconing in rtl8192cu seems to work such that the user needs to
> explicitly send one beacon frame, which the hardware then starts
> repeating. The explicitly sent frames show up in hostapd's mon.wlan0
> and then hostapd also prints out a message "unknown mgmt cb frame
> subtype 8". I don't know how to fix that. It doesn't seem to matter,
> though.
>
> Also, hostapd.conf should have "dtim_period=1", since the hardware
> doesn't change dtim count in the beacon frames it sends. Furthermore,
> the period is hardcoded to 1 in the realtek vendor driver. Is there a
> way for a driver to inform mac80211 and hostapd about this limitation?
>
> How does the patch look? My knowledge in this area is very limited:
> basically, I guess the patch is ok, since my kernel doesn't panic. :)
> (I realize that the patch modifies the common rtlwifi code, so it
> should condition the new beaconing code for rtl8192cu only.)

Changing rtlwifi is not acceptable when you only wish to modify a single driver. 
That code in any other routine than usb.c will affect all the other drivers.

I used my hostapd script to start an AP with rtl8192cu using the ESSID "TEST". 
After I did tat, I did an 'iw scan' with a different interface and got

BSS 00:1f:1f:c8:8e:cb (on wlan2)
         TSF: 3249538351 usec (0d, 00:54:09)
         freq: 2462
         beacon interval: 100
         capability: ESS Privacy ShortSlotTime (0x0411)
         signal: -30.00 dBm
         last seen: 24 ms ago
         SSID: TEST
         Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
         DS Parameter set: channel 11
         Country: US     Environment: Indoor/Outdoor
                 Channels [1 - 11] @ 20 dBm
         ERP: Barker_Preamble_Mode
         Extended supported rates: 24.0 36.0 48.0 54.0
         RSN:     * Version: 1
                  * Group cipher: CCMP
                  * Pairwise ciphers: CCMP
                  * Authentication suites: PSK
                  * Capabilities: 16-PTKSA-RC (0x000c)
         HT capabilities:
                 Capabilities: 0x186c
                         HT20
                         SM Power Save disabled
                         RX HT20 SGI
                         RX HT40 SGI
                         No RX STBC
                         Max AMSDU length: 7935 bytes
                         DSSS/CCK HT40
                 Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                 Minimum RX AMPDU time spacing: 16 usec (0x07)
                 HT TX/RX MCS rate indexes supported: 0-7, 32
         HT operation:
                  * primary channel: 11
                  * secondary channel offset: no secondary
                  * STA channel width: 20 MHz
                  * RIFS: 0
                  * HT protection: no
                  * non-GF present: 0
                  * OBSS non-GF present: 0
                  * dual beacon: 0
                  * dual CTS protection: 0
                  * STBC beacon: 0
                  * L-SIG TXOP Prot: 0
                  * PCO active: 0
                  * PCO phase: 0
         WMM:     * Parameter version 1
                  * BE: CW 15-1023, AIFSN 3
                  * BK: CW 15-1023, AIFSN 7
                  * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                  * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

Obviously, the rtl8192cu is beaconing with no changes to the wireless-testing 
code. This driver has the hooks to set the beacon time, but it is not being 
changed - that needs investigation. A second machine could authenticate and 
associate; however, I could get no ping throughput.

I will be looking at this driver when I get time; however, I must warn that I 
consider problems using these drivers as an AP to have low priority. You can; 
however, use your patch to make it work, but that patch will not be accepted.

Larry


