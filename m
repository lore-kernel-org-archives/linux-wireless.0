Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51405 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaG2Km1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 06:42:27 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so5875354wib.14
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2014 03:42:24 -0700 (PDT)
MIME-Version: 1.0
From: tara petric <tara.petric@gmail.com>
Date: Tue, 29 Jul 2014 12:42:04 +0200
Message-ID: <CAKXW2E8m=OJpo79LLkxG4hLU9ANEmTVS3dpSatDXAYZ88t0Bfw@mail.gmail.com> (sfid-20140729_124231_336585_3E483FF4)
Subject: a way to prevent authenticaion frames in IBSS mode for unfamiliar stations?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have noticed that when a WNIC running an IBSS network receives a
frame from an unfamiliar station, it (after adding the station ) sends
an Authentication frame before it's able to receive the intended
frame.

This seems like unnecessary behavior and I am wondering - is there a
way to somehow prevent this from user space? Or pre-add a particular
station, so that it wont go into ieee80211_ibss_rx_no_sta upon
receival? Or more generally is there a way to prevent authentication
frames being sent out alltogether from non-encrypted IBSS (since it's
not required by the standard)?

The reason I want to know about this is because I am trying to see if
it is possible to have minimal exchange of frames ( only useful
information ) with linux 80211 capabilites.

I'm guessing that this happens in this case, as well as the regular
IBSS join case, when this part of code is executed :
lxr.free-electrons.com/source/net/mac80211/ibss.c?v=3.10#L328

I am using Kernel Version 3.10.25

Thank you very much,
Tara
