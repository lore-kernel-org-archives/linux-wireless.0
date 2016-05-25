Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36584 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbcEYH4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 03:56:30 -0400
Received: by mail-oi0-f51.google.com with SMTP id j1so65967106oih.3
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2016 00:56:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <590f02bf-63a1-9510-dddb-d903fe03284e@broadcom.com>
References: <CACna6rzA1JcTjBsozR5nhCH9U9bKwceTNwLzeQ-Ds97NECVaeQ@mail.gmail.com>
	<CACna6rwgOuUtgjduwgQoZPFewZ3Wn2vgXapCvqw1ygbyt3Jqaw@mail.gmail.com>
	<56F1A9E9.5090803@broadcom.com>
	<CACna6ryFGQT56QGxsMF=a5Qi+eDp+3mByoxTQidWrxR6qRpBmA@mail.gmail.com>
	<56F273AB.2060001@broadcom.com>
	<CACna6rwrNWzU415zK43fiwBc+BbfosdiSrJk11=pCs7uZDYV=w@mail.gmail.com>
	<590f02bf-63a1-9510-dddb-d903fe03284e@broadcom.com>
Date: Wed, 25 May 2016 09:56:29 +0200
Message-ID: <CACna6rwscDHDikSw3+xZQiD0Cz8OdNa=MV37ZcFXToVkmMQ1+g@mail.gmail.com> (sfid-20160525_095657_905990_7A4A055C)
Subject: Re: Problem with brcmfmac removing extra interface
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 May 2016 at 21:49, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> Looking into the firmware code it turns out that the DOWN command brings
> down the entire stack iso single interface. This seems specific for some
> firmware branches so we have to find a better solution. Hante and I are
> looking into it.

I started working on brcmfmac few days ago and I realized that as
well. When having 4 AP interfaces and stopping hostapd nicely I get:

brcmfmac: [brcmf_fweh_handle_if_event] ifevent->action:3:BRCMF_E_IF_CHANGE
brcmfmac: action: 3 ifidx: 0 bsscfgidx: 0 flags: 0 role: 8

brcmfmac: [brcmf_fweh_handle_if_event] ifevent->action:2:BRCMF_E_IF_DEL
brcmfmac: action: 2 ifidx: 1 bsscfgidx: 2 flags: 0 role: 1
brcmfmac: brcmf_fweh_call_event_handler: no interface object

brcmfmac: [brcmf_fweh_handle_if_event] ifevent->action:2:BRCMF_E_IF_DEL
brcmfmac: action: 2 ifidx: 2 bsscfgidx: 3 flags: 0 role: 1
brcmfmac: brcmf_fweh_call_event_handler: no interface object

brcmfmac: [brcmf_fweh_handle_if_event] ifevent->action:2:BRCMF_E_IF_DEL
brcmfmac: action: 2 ifidx: 3 bsscfgidx: 4 flags: 0 role: 1
brcmfmac: brcmf_fweh_call_event_handler: no interface object

brcmfmac: [brcmf_fweh_handle_if_event] ifevent->action:1:BRCMF_E_IF_ADD
brcmfmac: action: 1 ifidx: 0 bsscfgidx: 0 flags: 0 role: 8
brcmfmac: adding wl0 (80:23:6a:a3:7d:95)

brcmfmac: [brcmf_fweh_handle_if_event] ifevent->action:3:BRCMF_E_IF_CHANGE
brcmfmac: action: 3 ifidx: 0 bsscfgidx: 0 flags: 0 role: 0

It means that all interfaces/BSS-es were dropped by firmware
internally and thanks to that we can create them again (start AP
again).

It doesn't happen if:
1) I simply add & remove interfaces manually with "iw"
2) I use BCM4366 and hostapd
In both above cases firmware keeps its internal interfaces/BSS-es and
I can't recreate interfaces.

-- 
Rafał
