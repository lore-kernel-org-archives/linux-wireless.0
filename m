Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37548 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbFELFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 07:05:32 -0400
Received: by wifx6 with SMTP id x6so16761126wif.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 04:05:31 -0700 (PDT)
Message-ID: <55718279.2010607@gmail.com> (sfid-20150605_130536_010653_846098E2)
Date: Fri, 05 Jun 2015 13:05:29 +0200
From: "christophe.ricard" <christophe.ricard@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: NFC: st21nfca: Add HCI transaction event support
References: <20150210090051.GA31867@mwanda> <20150605105918.GV11734@mwanda>
In-Reply-To: <20150605105918.GV11734@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Actually, i am sorry, i forgot to reply back on your email but i have 
tried to add comments in a follow up patch for st21nfca and st21nfcb:
st21nfca: https://lists.01.org/pipermail/linux-nfc/2015-March/003463.html
st21nfcb: https://lists.01.org/pipermail/linux-nfc/2015-March/003462.html

The actual answer from an nfc evt_transaction is a known structure with 
secure element application identifier (aid) + some data.

Please let me know if it is still not clear enough.

Best Regards

On 05/06/2015 12:59, Dan Carpenter wrote:
> I never got a response on this.  Is this remote exploitable or from the
> firmware?
>
> regards,
> dan carpenter
>
> On Tue, Feb 10, 2015 at 12:00:51PM +0300, Dan Carpenter wrote:
>> Hello Christophe Ricard,
>>
>> The patch 26fc6c7f02cb: "NFC: st21nfca: Add HCI transaction event
>> support" from Feb 1, 2015, leads to the following static checker
>> warning:
>>
>> 	drivers/nfc/st21nfca/st21nfca_se.c:321 st21nfca_connectivity_event_received()
>> 	error: 'skb->data[1]' from user is not capped properly
>>
>> drivers/nfc/st21nfca/st21nfca_se.c
>>     300  int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>>     301                                  u8 event, struct sk_buff *skb)
>>     302  {
>>     303          int r = 0;
>>     304          struct device *dev = &hdev->ndev->dev;
>>     305          struct nfc_evt_transaction *transaction;
>>     306
>>     307          pr_debug("connectivity gate event: %x\n", event);
>>     308
>>     309          switch (event) {
>>     310          case ST21NFCA_EVT_CONNECTIVITY:
>>     311                  break;
>>     312          case ST21NFCA_EVT_TRANSACTION:
>>     313                  if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
>>     314                      skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
>>     315                          return -EPROTO;
>>
>> Here we don't trust skb->data[0].
>>
>>     316
>>     317                  transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
>>     318                                                     skb->len - 2, GFP_KERNEL);
>>     319
>>     320                  transaction->aid_len = skb->data[1];
>>     321                  memcpy(transaction->aid, &skb->data[2], skb->data[1]);
>>                                                                  ^^^^^^^^^^^^
>> But here we trust skb->data[1].
>>
>> NFC code is hard to analyze because sometimes skb->data[] comes from the
>> firmware and holds trusted values.  But sometimes it comes from the
>> network and can overflow.  Smatch marks it all as untrusted so it causes
>> a lot of false postives.
>>
>> Some of them have comments like:
>>
>> 	net/nfc/hci/core.c:218 nfc_hci_cmd_received()
>> 	error: buffer overflow 'hdev->pipes' 127 <= 255
>>
>> But this one doesn't have a comment so it's hard for me as an outsider
>> to say if this is a bug or not.
>>
>>     322
>>
>> regards,
>> dan carpenter

