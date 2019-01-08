Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F46C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EBDD20883
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 22:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfAHWUP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 17:20:15 -0500
Received: from mail-oln040092068058.outbound.protection.outlook.com ([40.92.68.58]:21568
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728015AbfAHWUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 17:20:14 -0500
Received: from HE1EUR02FT025.eop-EUR02.prod.protection.outlook.com
 (10.152.10.59) by HE1EUR02HT083.eop-EUR02.prod.protection.outlook.com
 (10.152.11.232) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1471.13; Tue, 8 Jan
 2019 22:20:10 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com (10.152.10.60) by
 HE1EUR02FT025.mail.protection.outlook.com (10.152.10.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1471.13 via Frontend Transport; Tue, 8 Jan 2019 22:20:10 +0000
Received: from AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a]) by AM6PR07MB5608.eurprd07.prod.outlook.com
 ([fe80::68b1:73c3:455d:de2a%2]) with mapi id 15.20.1516.010; Tue, 8 Jan 2019
 22:20:10 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 1/4] rtl8723ae: Take the FW LPS mode handling out
Thread-Topic: [PATCH v3 1/4] rtl8723ae: Take the FW LPS mode handling out
Thread-Index: AQHUpVMW1dQwmrtP7EOElJ7UgzyQKqWlpGO9gABRlgA=
Date:   Tue, 8 Jan 2019 22:20:10 +0000
Message-ID: <AM6PR07MB5608485F4D295B7DE5E00A0DE48A0@AM6PR07MB5608.eurprd07.prod.outlook.com>
References: <DB7PR07MB535316A20C8447096DBC822DE4880@DB7PR07MB5353.eurprd07.prod.outlook.com>
 <875zuzqctc.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <875zuzqctc.fsf@kamboji.qca.qualcomm.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:206:14::49) To AM6PR07MB5608.eurprd07.prod.outlook.com
 (2603:10a6:20b:6f::21)
x-incomingtopheadermarker: OriginalChecksum:957DD6C58A6FAD965940A81D39EABDD8F1B652FB7212EC848CB4C6C09821CF4E;UpperCasedChecksum:8745FE5092B997B585FCD429DC97297067141C2AD048BA2E959539BEA9AC3230;SizeAsReceived:8956;Count:65
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [J/sOYt11xHoPHK5fRRtJa+VMfEeo+LZt]
x-microsoft-original-message-id: <193bd17c-8f12-aa33-74a7-c9fa9a90246f@hotmail.de>
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1EUR02HT083;6:KPLH69ctTezlkJ133pPDBwDDaeXrKqMGQ6aUpPpvf2X/mBM8ZC1dDd7SmlHjDz8xhpVdZ1k7K2641dM/+ucv1VnpjoYTbmdCNlukn2zLYw63vEDpPI21B63u3UHCtswitS/H/k+jzHirkitZ8TptiylBQY90GTSEZlTTp6Dnr2AQ1E7YdxZ3LPVpGbmRX34PMdLrN21nbxKUDYiW8JTqdRnK+674dB1fMu06ByAVGHE/x6ey/1l6O79wShysuL6CcQ6BcpAr2DoUBz/HHKoeGUYk1GkFq623pRp/rx6XS+TZz87xf/ES8ccaiqdszgm83Z1ZS3SuXwOHqCDznhc4n6SZy5v7Wld3X1+RD4OGyfeSiIGOYPpS1H46dOGdEl99TO+K3TTk1BvxgENp2SsI2T/K7YsdsRJmGDasf8H2+mbiH2HQy29shC+tFWZVmcAr5OuE6PkXhkodABVYcGvyVw==;5:DF6T8gJUl7DHZv1dldn8vFWGHqYUOdPnX28m91larEievcQG9bwoaxun2blBpRI7EYet5fbwkAyYQU8In2t88+6Nj/jHFuurYS/TxERCMfs0wm7oys0GwdQwNVzRSfLH760LJ5suk7ysgDoTKcGk6U9E3rwYnTL4KiD77OkGbA0=;7:GsfIXAMCeBq3fGhd+jDEE0nVX7gucb4WkFVYsS5VVpDLhaQGtsXSd3YGtijioRZgeJE9bPt0vBHqAxgPC4nlx/WK1qz0nK2btkOQsjVA2KUa0n4okLKYGJWRpfWdIeisQlnVV/CgNcrE8UAbG3Wplg==
x-incomingheadercount: 65
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:HE1EUR02HT083;
x-ms-traffictypediagnostic: HE1EUR02HT083:
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(4566010)(82015058);SRVR:HE1EUR02HT083;BCL:0;PCL:0;RULEID:;SRVR:HE1EUR02HT083;
x-microsoft-antispam-message-info: bGTMq1lAuyp2nlMuYloPfmwsocgSEGss2Bd0iukbEOdlRCSjQ8cNKez2cM5CAtN0
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <8F1AEF01D7017547B6C1DF8E5F67BC06@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-Network-Message-Id: e4296a1f-4885-4b53-bec9-08d675b773a1
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: d4d70346-2c10-4f39-8c00-e767963926d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 22:20:09.5266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT083
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/8/19 6:27 PM, Kalle Valo wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This appears to trigger a firmware bug and causes severe
>> problems with rtl8723ae PCI devices.
>>
>> When the power save mode is activated for longer periods
>> of time the firmware stops to receive any packets.
>>
>> This problem was exposed by commit 873ffe154ae0 ("rtlwifi:
>> Fix logic error in enter/exit power-save mode").
>>
>> Previously the power save mode was only active rarely and
>> only for a short time so that the problem was not noticeable.
>>
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>> v2: Adjust the defaults of swlps and fwlps module
>> parameters to match the firmware capabilities instead of removing
>> the whole code, so it can be easily re-activated once a firmware
>> update is available.
>>
>> v3: Make the title fit in one line.
> 
> hotmail.de made me suspicious and indeed my Spidey sense was right:
> 
> Applying: rtl8723ae: Take the FW LPS mode handling out
> Using index info to reconstruct a base tree...
> .git/rebase-apply/patch:22: trailing whitespace.
>         .swctrl_lps = true,
> .git/rebase-apply/patch:23: trailing whitespace.
>         .fwctrl_lps = false,
> .git/rebase-apply/patch:33: trailing whitespace.
> MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
> .git/rebase-apply/patch:34: trailing whitespace.
> MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
> error: patch failed: drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c:266
> error: drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c: patch does not apply
> error: Did you hand edit your patch?
> It does not apply to blobs recorded in its index.
> Patch failed at 0001 rtl8723ae: Take the FW LPS mode handling out
> 
> Did you use Outlook to send this patch or what? Anyway, it's strongly
> suggested to use git to submit the patches (and not use Outlook servers
> either as they are notorious in breaking our patches):
> 

No, I did use firefox with the settings which I found at
https://www.kernel.org/doc/html/latest/process/email-clients.html#email-clients

I think all that is wrong with the message body is it is base64 encoded, and all the
lines end with CRLF, and it seems the CR is the trailing whitespace.

I think the Character Encoding/UTF-8 does not work right with
Exchange Servers.

What Character Encoding would git send-email use?  UTF-8?

So I will try to send the patches again, with 7-bit encoded message bodies.
Actually it will be quoted-printable, but I do not use any umlauts.


So for the records, I did open about:config in the firefox preferences,
and change:

mailnews.send_default_charset from UTF-8 to ISO-8859-1

that I have already done before, but it was not sufficient:

mailnews.send_plaintext_flowed from true to false
mailnews.wraplength from 72 to 0


Thanks
Bernd.
