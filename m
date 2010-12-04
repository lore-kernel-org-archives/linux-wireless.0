Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44500 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab0LDVzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 16:55:06 -0500
Received: by qyk11 with SMTP id 11so2285202qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Dec 2010 13:55:06 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1291491764-6655-1-git-send-email-kilroyd@googlemail.com>
References: <1291491764-6655-1-git-send-email-kilroyd@googlemail.com>
Date: Sat, 4 Dec 2010 22:55:05 +0100
Message-ID: <AANLkTi=nS+Du=CEk4=zqekJty=XnBjTUAj49L0Njz5BP@mail.gmail.com>
Subject: Re: [PATCH 1/2] orinoco: fix TKIP countermeasure behaviour
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, comes@naic.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 4, 2010 at 8:42 PM, David Kilroy <kilroyd@googlemail.com> wrote:
> Enable the port when disabling countermeasures, and disable it on
> enabling countermeasures.
>
> This bug causes the response of the system to certain attacks to be
> ineffective.
>
> It also prevents wpa_supplicant from getting scan results, as
> wpa_supplicant disables countermeasures on startup - preventing the
> hardware from scanning.
>
> wpa_supplicant works with ap_mode=2 because the commit handler
> re-enables to port.
>
> The log tends to look like:
>
> State: DISCONNECTED -> SCANNING
> Starting AP scan for wildcard SSID
> Scan requested (ret=0) - scan timeout 5 seconds
> EAPOL: disable timer tick
> EAPOL: Supplicant port status: Unauthorized
> Scan timeout - try to get results
> Failed to get scan results
> Failed to get scan results - try scanning again
> Setting scan request: 1 sec 0 usec
> Starting AP scan for wildcard SSID
> Scan requested (ret=-1) - scan timeout 5 seconds
> Failed to initiate AP scan.
>
> Reported by: Giacomo Comes <comes@naic@edu>
> Signed-off by: David Kilroy <kilroyd@googlemail.com>
> ---
>

Wrong Email - should be  <comes@naic.edu>?

- Sedat -
