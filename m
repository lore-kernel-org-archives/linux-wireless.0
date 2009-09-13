Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63284 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZIMAYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 20:24:47 -0400
Received: by ewy2 with SMTP id 2so2048042ewy.17
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2009 17:24:49 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: hostap@lists.shmoo.com
Subject: Re: A station can't reconnect after it wakes up
Date: Sun, 13 Sep 2009 02:24:43 +0200
Cc: Igor Perminov <igor.perminov@inbox.ru>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Artur Skawina <art.08.09@gmail.com>
References: <1248969930.29068.224.camel@sunlight> <1252767513.23427.26.camel@johannes.local> <1252799481.26765.145.camel@sunlight>
In-Reply-To: <1252799481.26765.145.camel@sunlight>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909130224.43258.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 September 2009 01:51:21 Igor Perminov wrote:
> On Sat, 2009-09-12 at 08:58 -0600, Johannes Berg wrote:
> > On Fri, 2009-09-11 at 02:03 +0400, Igor Perminov wrote:
> > 
> > > Jouni suggests to not buffer Auth/Assoc frames at all, independently of
> > > station's PS state. 
> > 
> > Ok, works for me.
> > 
> > > I think, it isn't enough, because an AP should send
> > > a number of EAPOL Key frames after that, which are data frames and
> > > therefore will be buffered anyway.
> > 
> > That's not a problem though since the handshake will be in data frames
> > and synchronise the PS state on both ends via the sleep bit.
> > 
> > > I think mac80211 in AP mode should reset WLAN_STA_PS flag of the station
> > > (and purge frames having been buffered previously if any) on an event
> > > indicating beginning of authentication.
> > > The event may be one of the following:
> > > A) An Auth frame being received from the station.
> > > B) An Auth frame being sent to the station.
> > > C) A special API call from an application (hostapd), when it is
> > > receiving an Auth frame from the station and is beginning
> > > authentication/association.
> > > 
> > > Johannes, what do you think of these approaches?
> > 
> > I think this is not necessary. Just make sure that auth/assoc frames
> > aren't buffered.
> 
> The handshake is begun by the AP, which considers the STA is in PS mode.
>
> So, first EAPOL Key frame is buffered already.
> The AP informs the STA by TIM after that of course. But I think, there
> is no any guarantee that the STA analyzes TIM at this point, because the
> STA considers itself not power-saving.
> 
> I've implemented transmitting Auth and Assoc Response frames without
> buffering on current wireless-testing and got the following result with
> my Windows Mobile 6 PDA as a STA.
> The AP buffers first EAPOL Key frame, gets a timeout, tries to resend
> the frame and buffers it again. Some time later the STA sends EAPOL
> Start frame, which reports to the AP that the STA isn't sleeping. After
> that reconnection succeeds.
> Normally the PDA doesn't send EAPOL Start, and I have no idea, why it
> does so when it doesn't receive a EAPOL Key frame in time.
> And I can at least assume that the PDA ignores TIM at the handshake
> stage.
> 
> Unfortunately, I can't test another STA implementation, because my
> laptop under Ubuntu Linux sends a Disassoc frame before going down,
> which prevents PS state misunderstanding.
> 
> I've nowhere found in 802.11-2007 document that a STA should send EAPOL
> Start at the beginning of 4-way handshake. So, there is no any guarantee
> that every STA implementation can synchronize its PS state with the AP.
> 
> And moreover, my ASUS WL-500GP access point (it works under Linux 2.4
> and doesn't utilize hostapd) processes reconnection without manipulating
> TIM and causing a STA to send EAPOL Start. Probably, it just reset its
> internal PS state of the STA at the beginning of reconnection.
> 
> Would it be better to reset WLAN_STA_PS flag to get a more reliable
> solution may be?

well, you can take a look right here: (comment)

net/mac80211/rx.c - ieee80211_rx_h_sta_process

        /*
         * Change STA power saving mode only at the end of a frame
         * exchange sequence.
         */
        if (!ieee80211_has_morefrags(hdr->frame_control) &&
            (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
             rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
                if (test_sta_flags(sta, WLAN_STA_PS)) {
                        /*
                         * Ignore doze->wake transitions that are
                         * indicated by non-data frames, the standard
                         * is unclear here, but for example going to
                         * PS mode and then scanning would cause a
                         * doze->wake transition for the probe request,
                         * and that is clearly undesirable.
                         */
--- from here --- 
                        if (ieee80211_is_data(hdr->frame_control) &&
                            !ieee80211_has_pm(hdr->frame_control))
                                rx->sent_ps_buffered += ap_sta_ps_end(sta);
--- to here ---

                } else {
                        if (ieee80211_has_pm(hdr->frame_control))
                                ap_sta_ps_start(sta);
                }
	}

to trigger for (de-)auth/(de/re)assoc too in order to reset the PS state.

Regards,
   Chr 
