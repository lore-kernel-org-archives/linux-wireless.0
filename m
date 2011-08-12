Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61734 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1HLTIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:08:41 -0400
Received: by vws1 with SMTP id 1so2690672vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 12:08:40 -0700 (PDT)
Message-ID: <4E457A30.3010701@lwfinger.net> (sfid-20110812_210852_017270_FA3796F4)
Date: Fri, 12 Aug 2011 14:08:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/14] staging: brcm80211: use wait queues instead of
 semaphores in wl_cfg80211.c
References: <1313156101-16817-1-git-send-email-arend@broadcom.com> <1313156101-16817-2-git-send-email-arend@broadcom.com> <CACna6rzmaxzezN-OPTLvXyFOZOsoq6XCds4P-FOEz27FzJz+Jg@mail.gmail.com> <4E455877.6090901@broadcom.com> <4E45781E.8070508@broadcom.com>
In-Reply-To: <4E45781E.8070508@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 01:59 PM, Franky Lin wrote:
> If you are refering to this line
>  >>> + } while ((e = brcmf_deq_event(cfg_priv)));
>
> The extra parentheses are added to fix a compiler warning:
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c: In function
> ‘brcmf_event_handler’:
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:3576: warning: suggest
> parentheses around assignment used as truth value

Does checkpatch allow that assignment in the while statement? I would expect it 
to want you to

		e = brcmf_deq_event(cfg_priv);
	} while (e);

Larry
