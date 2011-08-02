Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33355 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab1HBRfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 13:35:31 -0400
Received: by fxh19 with SMTP id 19so38202fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 10:35:30 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Aug 2011 18:35:30 +0100
Message-ID: <CAGq3pz40rsMudofq6Njr0_h1G=EqEigGL-NkODj8Rb6h2bMGMQ@mail.gmail.com> (sfid-20110802_193534_769706_38EDCD89)
Subject: Making sense of cfg80211_scan_request.n_ssids
From: Daniel Drake <dsd@laptop.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking at libertas scanning code, and I'm wondering exactly what
the cfg80211_scan_request.n_ssids field is supposed to mean.

I would guess that it is supposed to indicate how many SSIDs should be
explicitly scanned for. However, this doesn't seem to be the case.

  iwlist eth0 scan essid test
  iw dev eth0 scan ssid test

Both of those commands result in libertas being called with
cfg80211_scan_request with n_ssids=1 and the "test" SSID present in
cfg80211_scan_request.ssids[0], as expected.


  iwlist eth0 scan
  iw dev eth0 scan

Both of those commands result in libertas being called with
cfg80211_scan_request with n_ssids=1 and a zero-length SSID present in
cfg80211_scan_request.ssids[0].
Is this a bug? I would expect it to be passed n_ssids=0 in this case.

Thanks,
Daniel
