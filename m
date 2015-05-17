Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35863 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbEQRUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 13:20:05 -0400
Received: by lagv1 with SMTP id v1so188230055lag.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 10:20:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55586D8D.7040407@gmail.com>
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
	<55575AC8.2060301@lwfinger.net>
	<CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
	<5557844B.4040108@lwfinger.net>
	<CAJ=9CzamCxkwVtTtUzU9zatocUPz0W+3f0Kgm6N0tDMWbcP_LA@mail.gmail.com>
	<55586D8D.7040407@gmail.com>
Date: Sun, 17 May 2015 20:20:03 +0300
Message-ID: <CAJ=9CzbxScr7SJjhxnxAWt+xS-A8VR-_PQs0BbbdUp7xCaG2aw@mail.gmail.com> (sfid-20150517_192019_848791_66BEA72E)
Subject: Re: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 May 2015 at 13:29, Arend van Spriel <aspriel@gmail.com> wrote:
> On 17-05-15 06:25, Haggai Eran wrote:
>>
>> On 16 May 2015 at 20:54, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>
>>> Another location needed from gdb is "l *recv_func+0x8c".
>>
>>
>> Here it is:
>> (gdb) l *recv_func+0x8c
>> 0x17094 is in recv_func (drivers/staging/rtl8712/rtl8712_recv.c:1004).
>> 999                     r8712_free_recvframe(orig_prframe,
>> pfree_recv_queue);
>> 1000                    goto _exit_recv_func;
>> 1001            }
>> 1002    _exit_recv_func:
>> 1003            return retval;
>> 1004    }
>> 1005
>> 1006    static int recvbuf2recvframe(struct _adapter *padapter, struct
>> sk_buff *pskb)
>> 1007    {
>> 1008            u8 *pbuf, shift_sz = 0;
>>
>> I don't think this means the relevant call is the one at line 999. I
>> think it is an earlier call, after r8712_validate_recv_frame. Here's
>> the disassembly:
>
>
> can you provide the address of recv_func as well to determine the exact
> location in assembly.

Yes, it is in offset 0x17008 in the module:
> 00017008 <recv_func>:

Regards,
Haggai

>
>>          /* check the frame crtl field and decache */
>>          retval = r8712_validate_recv_frame(padapter, prframe);
>>     17070:       e1a00004        mov     r0, r4
>>     17074:       e1a01005        mov     r1, r5
>>     17078:       ebfffffe        bl      17bc0 <r8712_validate_recv_frame>
>>          if (retval != _SUCCESS) {
>>     1707c:       e3500001        cmp     r0, #1
>>                          r8712_free_recvframe(orig_prframe,
>> pfree_recv_queue);
>>                          goto _exit_recv_func;
>>                  }
>>          }
>>          /* check the frame crtl field and decache */
>>          retval = r8712_validate_recv_frame(padapter, prframe);
>>     17080:       e1a06000        mov     r6, r0
>>          if (retval != _SUCCESS) {
>>     17084:       0a000005        beq     170a0 <recv_func+0x98>
>>                  /* free this recv_frame */
>>                  r8712_free_recvframe(orig_prframe, pfree_recv_queue);
>>     17088:       e1a00005        mov     r0, r5
>>     1708c:       e1a01007        mov     r1, r7
>>     17090:       ebfffffe        bl      166e8 <r8712_free_recvframe>
>>                  r8712_free_recvframe(orig_prframe, pfree_recv_queue);
>>                  goto _exit_recv_func;
>>          }
>> _exit_recv_func:
>>          return retval;
>> }
>>     17094:       e1a00006        mov     r0, r6
