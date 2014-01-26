Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:56626 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaAZX4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 18:56:43 -0500
Message-ID: <52E5A0AE.7000009@erley.org> (sfid-20140127_005656_144854_A6D97814)
Date: Sun, 26 Jan 2014 17:56:30 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Benedikt Schwarz <beweta@gmx.com>, linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: Upload rate is ten times faster on Windows
References: <lc31d9$sma$1@ger.gmane.org>
In-Reply-To: <lc31d9$sma$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2014 07:09 AM, Benedikt Schwarz wrote:
> Hi,
>
> the upload rate of my Intel Centrino Wireless-N 100 BGN (REV=0x6C) with
> firmware version 39.31.5.1 build 32895 is about ten times faster on
> Windows 7 (~ 4500 KB/s) than on Linux (~ 500 KB/s) when uploading files
> to my NAS device. I'm running Kubuntu 13.10 with kernel
> 3.12.0-031200-generic.
>
> What could be the reason for this problem?
>
>
> Regards,
> Benedikt Schwarz
>
>
> === dmesg ===
>
> iwlwifi 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
> iwlwifi 0000:01:00.0: irq 44 for MSI/MSI-X
> iwlwifi 0000:01:00.0: loaded firmware version 39.31.5.1 build 32895
> op_mode iwldvm
> iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG disabled
> iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
> iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Wireless-N 100 BGN,
> REV=0x6C
> iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
> iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
>

Some questions which will greatly help in getting this resolved:

How are you connecting to the NAS?  Samba/Cifs?  NFS?  FTP?  How are you 
measuring your bandwidth?

Check /etc/modprobe.d/* for a line that has something like:

iwlwifi 11n_disable=1

A lot of distributions have that on by default as there have been issues 
with the iwlwifi driver using 802.11n.

Are you connecting to an open or wpa1+tkip access point?  Try using 
wpa2+ccmp instead.  This is required for 802.11n to work.  Windows may 
not be enforcing that portion of the standard.
