Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2AHQwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 11:52:05 -0500
Received: by iaeh11 with SMTP id h11so5505957iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 08:52:04 -0800 (PST)
Message-ID: <4F09C9B0.7080204@lwfinger.net> (sfid-20120108_175228_271234_D3F45EC3)
Date: Sun, 08 Jan 2012 10:52:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Strange behavior with rtl8192se
References: <20120108140753.GA2246@nautilus.holoscopio.com>
In-Reply-To: <20120108140753.GA2246@nautilus.holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2012 08:07 AM, Thadeu Lima de Souza Cascardo wrote:
> Hello, Larry.
>
> I have some problems with rtl819se that I couldn't find out what the
> reason is. I would like some ideas as to what look after, what debugging
> I can make or what changes I could try in the driver to fix it.
>
> The problem is that, sometimes, the adapter cannot receive probe
> responses from my AP. Other devices in my network can reconnect to it,
> so it's not a problem in the AP itself. There are other evidence that
> point out to a problem with rtl8192se, as I will point out below.
>
> So, usually this happens when, for some reason, I can't receive any
> packages from the network. After that, I try to reconnect, with no
> success. The problem is that, even after a reboot, I keep trying without
> no success to associate. I need to shutdown the machine to get the
> adapter back to work. And that's another evidence that the AP is not to
> blame. And it also happens with other AP I have around. Below is what I
> get in dmesg when trying to associate.
>
> wlan0: direct probe to 36:d9:98:74:ff:42 (try 1/3)
> wlan0: direct probe to 36:d9:98:74:ff:42 (try 2/3)
> wlan0: direct probe to 36:d9:98:74:ff:42 (try 3/3)
> wlan0: direct probe to 36:d9:98:74:ff:42 timed out
> wlan0: direct probe to 36:d9:98:74:ff:42 (try 1/3)
> wlan0: direct probe to 36:d9:98:74:ff:42 (try 2/3)
> wlan0: direct probe to 36:d9:98:74:ff:42 (try 3/3)
> wlan0: direct probe to 36:d9:98:74:ff:42 timed out
>
> Since a reboot didn't work and a shutdown did fix it, I have tried
> shutting down only the adapter, putting it into D3_cold state and then
> back into D0, but that didn't work. That may be a problem with my
> notebook and its ACPI implementation. What I have managed to do is to
> hibernate: after a resume from that, it works as if I have shutdown. So,
> it's really a matter of shutting down the adapter or the system, instead
> of rebooting.
>
> And that tells more: I have also tried to reload the driver and mac80211
> stack, with no success. And since hibernate works, that is in their
> favour to some extent. It indicates that's not a problem in a software
> state. Well, there is the suspend and resume functions, but since
> suspend didn't work and hibernate uses the same functions, they are not
> fixing anything, neither breaking it.
>
> So, what I suspect is either there is some state in the hardware, like a
> filter for the BSSID or anything like that, that is not being cleared by
> the driver, or there is something wrong with the platform, perhaps ACPI
> is doing something stupid. There is not much reason to suspect the
> latter, however, since this bug does not require me to switch rfkill off
> and on or to unplug the notebook from the wall. It just happens if I
> have to reconnect for any reason.
>
> Since the adapter is not receiving probe responses from my AP, I decided
> to run it on monitor too. And, well, it does not receive the probe
> responses from my AP, but receives from some APs nearby. If I try to
> associate with my other AP, however, it fails too. I have put another
> device in monitor state too and have seen that the AP is sending the
> responses, so the adapter is really sending the requests (which I also
> saw in the monitor), but it's just not receivig the responses.
>
> Note that this was all done two meters from the AP, so this should not
> be a matter of distance or power. The other AP, whose responses I see
> should be further away, since it's not in my apartment.
>
> Any clues? I have run these monitor tests using 3.2-rc6. But I have also
> run into this same problem running 3.2-03023-g02550d6, which is latest
> rc, containing a merge from the last net-next.

There are some changes in compat-wireless that are not in 3.2-git, but nothing 
that would cause this problem comes to mind. What is the PCI ID for your device? 
I have 3 with different stream configuration, and I want to test the one you are 
using.

I have not received any other reports of needing to power off to restore 
operation. For me, rtl8192se has become quite stable.

It certainly appears that your receiver is in some state that requires the power 
to be shut off. Rebooting without a power off should clear any filters, but I 
doubt that any are being set.

The only other piece of info that might be useful would be the output of 'sudo 
lspci -vvv' for the adapter used by the rtl8192se when it is working and when it 
has failed.

I am currently building the latest git pull from mainline to see if I can 
duplicate the problem.

Larry

