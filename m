Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28274C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 06:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA75120828
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 06:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfCZGQW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 02:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbfCZGQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 02:16:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9408410C94;
        Tue, 26 Mar 2019 06:16:21 +0000 (UTC)
Received: from localhost (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 369CE5C232;
        Tue, 26 Mar 2019 06:16:21 +0000 (UTC)
Date:   Tue, 26 Mar 2019 07:16:19 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Message-ID: <20190326061618.GA7200@redhat.com>
References: <20190313091252.GB2663@redhat.com>
 <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
 <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com>
 <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
 <20190313155028.GB5302@redhat.com>
 <CAKR_QV+=i_Sp26zCkTC9cAHrhVLq4w0FoxLVmD-T3wFyd-ruEQ@mail.gmail.com>
 <20190325142537.GA13884@redhat.com>
 <CAKR_QV+zUBKk=8UHiCnWQg9XCdB8zbMEcVSKEO7vFOR0Q2Yesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QV+zUBKk=8UHiCnWQg9XCdB8zbMEcVSKEO7vFOR0Q2Yesw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 26 Mar 2019 06:16:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 26, 2019 at 02:54:25AM +0100, Tom Psyborg wrote:
> On 25/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Thu, Mar 14, 2019 at 03:02:14PM +0100, Tom Psyborg wrote:
> >> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >>
> >> >
> >> > There should be no difference between enabling MFP with nohwcrypt and
> >> > without nohwcrypt,
> >>
> >> well there is. do you still want me to resend this with MFP enabled
> >> unconditionally for all chips?
> >
> > Please share your hostapd config file with MFP enabled.
> >
> > Stanislaw
> >
> >
> 
> ctrl_interface=/var/run/wpa_supplicant
> eapol_version=1
> ap_scan=1
> fast_reauth=1
> pmf=2
> network={
> 	ssid="OpenWrt"
> 	proto=WPA2
> 	key_mgmt=WPA-PSK
> 	pairwise=CCMP
> 	group=CCMP
> 	ieee80211w=2
> 	psk="u7e5hwh46uz7ergv"
> 	wpa_ptk_rekey=60
> }

This is supplicant config, I asked for hostapd. You can find it in
/tmp/run/hostapd-phy0.conf (I assume you use openwrt on QCA router,
or you use proprietary firmware ?).

Stanislaw
