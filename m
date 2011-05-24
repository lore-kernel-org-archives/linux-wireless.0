Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45223 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab1EXMs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 08:48:56 -0400
Received: by iyb14 with SMTP id 14so5214118iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 05:48:56 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 24 May 2011 05:48:36 -0700
Message-ID: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com> (sfid-20110524_144900_493095_DB10C2AE)
Subject: Initial automatic channel selection implementation
To: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
Cc: Matt Smith <Matt.Smith@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm looking to implement some form of Automatic Channel Selection on
Linux. What this would do is review all known channels where we can
initiate radiation on (beaconing modes of operation) and then pick the
best one based on some heuristics. Below are 3 stages I believe we can
take to start supporting this.

I - Simple solution:

  * Look for the frequency in a band that has the less amount of BSSes
with the lowest link quality

II - Load check:

  * In addition to the above take into consideration some metric for
load on the channel: frame count observed

III - Spectral / FFT data scan:

  * Do a spectral scan on each supported frequency and based on the
FFT of the data choose the channel which has the less amount of
interference. This requires FFT data to be sent from each driver to
userspace, userspace to parse it based on the chipset, and to classify
the data into some generic form.

The first solution should be a quick hack and I can likely implement a
proof of concept rather quickly with iw based on scan results. Would
likely be a very poor algorithm though. For load check I'd like to
hear ideas on what we can use, I was thinking simply using a monitor
interface to do a frame count over time on each channel and use this
information in combination with the BSS / link quality information
from phase I to form a decision. The first two should be usable with
any 802.11 mac80211 driver.

The Spectral stuff requires both driver enhancements and some nl80211
changes which enables drivers to export some vendor specific blob
which userspace can parse and use for analysis. This is the ideal
solution but requires quite a bit of work and it the hooks will be
vendor specific both for kernel / processing of the FFT binary data.
Not all devices will support this.

This is the roadmap I'll follow, let me know if you have any other suggestions.

  Luis
