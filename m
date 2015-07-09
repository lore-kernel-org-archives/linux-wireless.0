Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37144 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbGITMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 15:12:17 -0400
Received: by igpy18 with SMTP id y18so3715381igp.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 12:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559EC1FE.6000608@broadcom.com>
References: <1436464883-10504-1-git-send-email-zajec5@gmail.com>
	<559EC1FE.6000608@broadcom.com>
Date: Thu, 9 Jul 2015 21:12:16 +0200
Message-ID: <CACna6rxT-ABaGzx3XQpPtaZBFTpKi91KuEY77Sum-ztZ4aqWjQ@mail.gmail.com> (sfid-20150709_211220_518078_4340ED3A)
Subject: Re: WARNING: brcmfmac/core.c:1144 brcmf_netdev_wait_pend8021x
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2015 at 20:48, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/09/2015 08:01 PM, Rafał Miłecki wrote:
>> After fixing user space <-> brcmfmac communication for using valid MACs:
>> [PATCH] brcmfmac: set wiphy's addresses to provide valid MACs
>> i started testing multiple interfaces.
>>
>> It seems there are many bugs in brcmfmac :(
>
>
> Well, you are using the device outside its capability, because brcmfmac does
> not properly announce interface combinations. I will submit patches for
> that.

Really? I'm just running 3 interfaces, all of them in AP mode, nothing
unexpected I believe.


>> So after running 3 AP interfaces and switching my STA device between them
>> I
>> started seeing WARNINGs triggered by brcmf_netdev_wait_pend8021x. It was
>> brcmf_cfg80211_del_key that was calling above function.
>>
>> The problem is that brcmf_netdev_start_xmit increases interfaces's
>> pend_8021x_cnt on every transmission of ETH_P_PAE but brcmf_txfinalize
>> fails
>> (from time to time?) do decrease it.
>>
>> There is a bug in brcmf_txfinalize that stops it from finding an interface
>> for
>> the received TX transmission success. I added some debugging to brcmfmac
>> as you
>> can see below and this is what I got:
>> [   39.394022] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c72c1dc0 on ifidx:0
>> [   39.413251] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c72c1dc0 on ifidx:2
>> [   39.421887] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c725a7c0 on ifidx:1
>> [   39.431720] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c6a78a00 on ifidx:0
>> [   39.442829] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c725a7c0 but got invalid ifidx:1
>> [   39.451773] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c726ee80 on ifidx:2
>> [   39.460384] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c725a7c0 on ifidx:1
>> [   39.536224] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c725a7c0 but got invalid ifidx:1
>> [   51.884737] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c714cd00 on ifidx:1
>> [   51.895577] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c714cd00 but got invalid ifidx:1
>> [   51.904592] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c707de80 on ifidx:2
>> [   51.913195] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c7011e80 on ifidx:0
>> [   51.922900] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c725a280 on ifidx:1
>> [   51.933988] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c725a280 but got invalid ifidx:1
>> [   51.942979] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c714cd00 on ifidx:2
>> [   51.951602] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c707de80 on ifidx:0
>> [   55.228402] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING
>> pend_8021x_cnt:4
>> [   55.278395] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING
>> pend_8021x_cnt:4
>> [   55.328394] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING
>> pend_8021x_cnt:4
>> [   55.336211] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c7070b80 on ifidx:2
>> [   55.347075] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c7070b80 and decreased pend_8021x_cnt for ifidx:2 but got negative count
>> -1!
>> [   55.387991] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c6a78a00 on ifidx:1
>> [   55.396601] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c7070b80 on ifidx:0
>> [   55.406245] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c707d400 on ifidx:2
>> [   55.417257] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c6a78a00 but got invalid ifidx:1
>> [   55.426144] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c707d400 and decreased pend_8021x_cnt for ifidx:2 but got negative count
>> -1!
>> [   55.439019] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c714cd00 on ifidx:1
>> [   55.447611] brcmfmac: [brcmf_netdev_start_xmit] Transmitting ETH_P_PAE
>> skb:c72c2580 on ifidx:0
>> [   55.498397] brcmfmac: [brcmf_netdev_wait_pend8021x] WARNING
>> pend_8021x_cnt:6
>> [   55.504785] brcmfmac: [brcmf_txfinalize] Finalized ETH_P_PAE
>> skb:c714cd00 but got invalid ifidx:1
>>
>> As you can see brcmf_txfinalize fails to find interface for ifidx:1. Why
>> is
>> that? It seems that drvr->iflist is an array indexed by bssidx, but
>> brcmf_txfinalize uses ifidx to access it. Obviously ifidx != bssidx.
>>
>> This also results in decreasing pend_8021x_cnt for wrong interfaces and
>> some
>> negative values.
>>
>> Will you fix this?
>
>
> I have some patches reworking the driver using drvr->iflist. One of the
> fixes involves calling brcmf_txfinalize with brcmf_if instance. I need to do
> more testing on those patches before submitting them. If you are willing to
> give them a try as well I can provide them.

Yes, please! :)

-- 
Rafał
