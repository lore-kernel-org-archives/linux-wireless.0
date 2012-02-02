Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2BBOU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 09:20:57 -0500
Date: Thu, 2 Feb 2012 08:20:53 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: CTS timeout issue with AR9285
Message-ID: <20120202142053.GA24483@ubuntu-macmini> (sfid-20120202_152100_774590_5BEBDF76)
References: <20120202042521.GA20635@ubuntu-macmini>
 <CAD2nsn0tk_A18vjsCzgO2_7swuM=VPghyTaiHjkHAUc3h3+MiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD2nsn0tk_A18vjsCzgO2_7swuM=VPghyTaiHjkHAUc3h3+MiQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 02, 2012 at 04:58:23PM +0530, Mohammed Shafi wrote:
> On Thu, Feb 2, 2012 at 9:55 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > I recently updated a machine with AR9285 wireless from kernel version
> > 3.0 to 3.2 and saw that wireless had become slow and unreliable. It
> > seems that the problem is extremely frequent CTS timeouts, which began
> > happening with commit adb5066 (ath9k_hw: do not apply the 2.4 ghz ack
> > timeout workaround to cts). Restoring the CTS timeout to the value prior
> > to this commit on top of 3.2 gets performance back to what it was with
> > 3.0.
> 
> does the environment is a noisy one (or) clear one

It's relatively clear, there isn't much activity at all on the channel
besides this card and the AP. And like I said, other cards aren't having
this problem. Using wireshark I can also see that RTS frames are being
sent repeatedly even though the AP responds with CTS frames.
