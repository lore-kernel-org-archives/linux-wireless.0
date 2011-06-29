Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42550 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1F2I4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 04:56:37 -0400
Received: by gyh3 with SMTP id 3so392995gyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 01:56:36 -0700 (PDT)
Message-ID: <4E0AE8C1.9090809@fedoraproject.org> (sfid-20110629_105641_056873_DC2AB5B3)
Date: Wed, 29 Jun 2011 10:56:33 +0200
From: Michel Alexandre Salim <salimma@fedoraproject.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n functionality
References: <4E0A2F8A.8010102@fedoraproject.org> <20110628215757.GA14975@jm.kir.nu>
In-Reply-To: <20110628215757.GA14975@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2011 11:57 PM, Jouni Malinen wrote:
> On Tue, Jun 28, 2011 at 09:46:18PM +0200, Michel Alexandre Salim wrote:
>> Some wireless base stations implement 802.11n mode in ways that
>> open-source drivers cannot handle properly, resulting in very
>> unstable connections. This patch introduces an '11n_disable' option
>> to the ath9k driver, similar to the same option for the iwlagn
>> driver.
>
> What is so special about this that makes it impossible for open source
> drivers to handle? The proper approach here would be to figure out what
> is causing the interop issue and fix (or more likely, work around) that.

To be honest, I'm not sure. Similar problems have cropped up over the 
years, with various different base stations. In this case I *might* be 
able to find out what base stations we're actually using in the building 
-- they're managed by a different organization so it might take time. In 
cases where it's a free wifi at a cafe somewhere it'd be harder to try 
and debug.

>
> In addition, if this is really needed, why would this be a driver
> specific hack rather than providing a shared mechanism in mac80211 to
> disable 802.11n support? It would sound strange if there would need to
> be a new module parameter in every 802.11n driver to handle something
> like this.
>
I agree with you and Adrian; it should ideally be in the 802.11 stack. 
But as Ben noted, it does have a useful purpose -- for debugging.

If the maintainers are agreeable to a shared mac80211 mechanism, which 
is the preferred way to handle this -- get this in, then refactor *both* 
iwlagn and ath9k to use it, or to implement a shared mechanism, 
demonstrate it with ath9k, then fix iwlagn later?

Thanks,

-- 
Michel Alexandre Salim
µblog:      http://identi.ca/hircus
             http://twitter.com/hircus
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments
